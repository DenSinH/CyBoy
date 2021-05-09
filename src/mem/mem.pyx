from src.mem.IO cimport *
from libc.stdio cimport printf
from libc.stdlib cimport exit
from libc.stdio cimport fopen, fclose, FILE, fread, fwrite, fseek, printf, SEEK_END, SEEK_SET, ftell
from src.mem.mappers.MBC1 cimport MBC1



cdef MemoryEntry MakeRW(unsigned char* data) nogil:
    cdef MemoryEntry entry 
    entry.read_ptr.data = data
    entry.read = True
    entry.write_ptr.data = data
    entry.write = True
    return entry

cdef MemoryEntry MakeROM(unsigned char* data) nogil:
    cdef MemoryEntry entry 
    entry.read_ptr.data = data
    entry.read = True
    entry.write_ptr.callback = NULL
    entry.write = False
    return entry

cdef MemoryEntry MakeUnused() nogil:
    cdef MemoryEntry entry 
    entry.read_ptr.data = NULL
    entry.read = False
    entry.write_ptr.callback = NULL
    entry.write = False
    return entry

cdef MemoryEntry MakeIO(read_callback read, write_callback write) nogil:
    cdef MemoryEntry entry 
    entry.read_ptr.callback = read
    entry.read = False
    entry.write_ptr.callback = write
    entry.write = False
    return entry

cdef MemoryEntry MakeComplexWrite(unsigned char* data, write_callback write) nogil:
    cdef MemoryEntry entry 
    entry.read_ptr.data = data
    entry.read = True
    entry.write_ptr.callback = write
    entry.write = False
    return entry

cdef unsigned char read_unimplemented(MEM mem, unsigned short address) nogil:
    printf("read from unimplemented address %04x\n", address)
    exit(-1)

cdef void write_unimplemented(MEM mem, unsigned short address, unsigned char value) nogil:
    printf("write %02x to unimplemented address %04x\n", value, address)
    exit(-2)

cdef MemoryEntry MakeUnimplemented() nogil:
    cdef MemoryEntry entry 
    entry.read_ptr.callback = read_unimplemented
    entry.read = False
    entry.write_ptr.callback = write_unimplemented
    entry.write = False
    return entry

cdef MemoryEntry MakeUnimpIO() nogil:
    cdef MemoryEntry entry 
    entry.read_ptr.callback = read_unimpIO
    entry.read = False
    entry.write_ptr.callback = write_unimpIO
    entry.write = False
    return entry

cdef MemoryEntry MakeComplexRead(read_callback read, unsigned char* data) nogil:
    cdef MemoryEntry entry 
    entry.read_ptr.callback = read
    entry.read = False
    entry.write_ptr.data = data
    entry.write = True
    return entry


cdef inline void write_ROM(MEM mem, unsigned short address, unsigned char value) nogil:
    # printf("MBC1 write %02x to %04x\n", value, address)
    mem.mapper.write8(address, value)

cdef class MAPPER:

    def __cinit__(MAPPER self, MEM mem, unsigned char ROM_amount, unsigned char RAM_amount):
        self.mem = mem
        self.ROM_amount = ROM_amount
        self.RAM_amount = RAM_amount
        self.ROM_bank = 1
    
    cdef void write8(MAPPER self, unsigned short address, unsigned char value) nogil:
        return
    
    cdef void init_mmap(MAPPER self) nogil:
        cdef unsigned int i
        # default no mapper ROM
        for i in range(0x4000):
            self.mem.MMAP[i] = MakeComplexWrite(&self.ROM[0][i], write_ROM)

        for i in range(0x4000):
            self.mem.MMAP[0x4000 + i] = MakeComplexWrite(&self.ROM[1][i], write_ROM)
    
    cdef void load_rom(MAPPER self, str file_name):
        cdef FILE *rom 
        rom = fopen(file_name.encode("UTF-8"), "rb")
        if rom is NULL:
            raise FileNotFoundError(f"File {file_name} does not exist")

        fseek(rom, 0, SEEK_END)
        cdef unsigned long long rom_size = ftell(rom)
        fseek(rom, 0, SEEK_SET)
        fread(&self.ROM, rom_size, 1, rom)
        fclose(rom)

        self.init_mmap()


cdef class MEM:
    
    def __cinit__(self):
        cdef unsigned int i
        for i in range(0x4000):
            self.MMAP[i] = MakeROM(&self.mapper.ROM[0][i])
        
        # if we want to use the boot rom
        for i in range(0x100):
            self.MMAP[i] = MakeROM(&self.BOOT[i])

        for i in range(0x4000):
            self.MMAP[0x4000 + i] = MakeROM(&self.mapper.ROM[1][i])

        for i in range(0x2000):
            self.MMAP[0x8000 + i] = MakeRW(&self.VRAM[i])

        for i in range(0x2000):
            self.MMAP[0xa000 + i] = MakeUnused()

        for i in range(0x1000):
            self.MMAP[0xc000 + i] = MakeRW(&self.WRAMlo[i])
        for i in range(0x1000):
            self.MMAP[0xd000 + i] = MakeRW(&self.WRAMhi[i])

        for i in range(0x1000):  # ECHO RAM
            self.MMAP[0xe000 + i] = MakeRW(&self.WRAMlo[i])
        for i in range(0xe00):   # ECHO RAM
            self.MMAP[0xf000 + i] = MakeRW(&self.WRAMhi[i])

        for i in range(0xa0):
            self.MMAP[0xfe00 + i] = MakeRW(&self.OAM[i])

        for i in range(0x60):
            self.MMAP[0xfea0 + i] = MakeUnused()

        for i in range(0x80):   # IO
            self.MMAP[0xff00 + i] = MakeUnimpIO()

        self.MMAP[0xff00] = MakeComplexRead(read_JOYP, &self.IO.JOYP)
        self.MMAP[0xff01] = MakeIO(NULL, write_SB)
        self.MMAP[0xff02] = MakeIO(NULL, NULL)  # todo
        self.MMAP[0xff04] = MakeComplexWrite((<unsigned char*>&self.IO.DIV) + 1, write_DIV)
        self.MMAP[0xff05] = MakeRW(&self.IO.TIMA)
        self.MMAP[0xff06] = MakeRW(&self.IO.TMA)
        self.MMAP[0xff07] = MakeComplexWrite(&self.IO.TAC, write_TAC)
        self.MMAP[0xff0f] = MakeComplexWrite(&self.IO.IF_, write_IF)
        self.MMAP[0xff40] = MakeRW(&self.IO.LCDC)
        self.MMAP[0xff41] = MakeComplexWrite(&self.IO.STAT, write_STAT)
        self.MMAP[0xff42] = MakeRW(&self.IO.SCY)
        self.MMAP[0xff43] = MakeRW(&self.IO.SCX)
        self.MMAP[0xff44] = MakeROM(&self.IO.LY)
        self.MMAP[0xff45] = MakeRW(&self.IO.LYC)
        self.MMAP[0xff46] = MakeComplexWrite(&self.IO.DMA, write_DMA)
        self.MMAP[0xff47] = MakeRW(&self.IO.BGP)
        self.MMAP[0xff48] = MakeRW(&self.IO.OBP[0])
        self.MMAP[0xff49] = MakeRW(&self.IO.OBP[1])
        self.MMAP[0xff4a] = MakeRW(&self.IO.WY)
        self.MMAP[0xff4b] = MakeRW(&self.IO.WX)
        self.MMAP[0xff50] = MakeIO(NULL, write_UnmapBoot)

        for i in range(0x7f):
            self.MMAP[0xff80 + i] = MakeRW(&self.HRAM[i])

        self.MMAP[0xffff] = MakeComplexWrite(&self.IO.IE, write_IE)  # IE

    cdef void load_rom(MEM self, str file_name):
        cdef FILE *rom 
        rom = fopen(file_name.encode("UTF-8"), "rb")
        if rom is NULL:
            raise FileNotFoundError(f"File {file_name} does not exist")

        fseek(rom, 0x147, SEEK_SET)
        cdef unsigned char cartridge_type
        cdef unsigned char ROM_size, RAM_size
        fread(&cartridge_type, 1, 1, rom)
        fread(&ROM_size, 1, 1, rom)
        fread(&RAM_size, 1, 1, rom)
        fclose(rom)

        printf("cartridge_type %x, ROM size %x, RAM size %x\n", cartridge_type, ROM_size, RAM_size)

        if RAM_size == 0:
            RAM_size = 0
        elif RAM_size == 1:
            RAM_size = 0
        elif RAM_size == 2:
            RAM_size = 1
        elif RAM_size == 3:
            RAM_size = 4
        elif RAM_size == 4:
            RAM_size = 16
        elif RAM_size == 5:
            RAM_size = 8
        
        if cartridge_type == 0:
            self.mapper = MAPPER(self, 0, 0)  # no MBC
        elif cartridge_type == 1:
            self.mapper = MBC1(self, 2 << ROM_size, 0)
        elif cartridge_type == 2 or cartridge_type == 3:
            self.mapper = MBC1(self, 2 << ROM_size, RAM_size)
        else:
            raise Exception(f"Unimplemented mapper: {cartridge_type}")
        self.mapper.load_rom(file_name)