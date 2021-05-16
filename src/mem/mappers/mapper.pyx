from src.mem.mem cimport MakeComplexWrite, MakeUnused
from libc.stdio cimport fopen, fclose, FILE, fread, fwrite, fseek, printf, SEEK_END, SEEK_SET, ftell
from libcpp cimport bool


cdef inline void write_ROM(MEM mem, unsigned short address, unsigned char value) nogil:
    # printf("MBC write %02x to %04x\n", value, address)
    mem.mapper.write8(address, value)

cdef class MAPPER:

    def __cinit__(MAPPER self, char* file_name, MEM mem, unsigned char ROM_amount, unsigned char RAM_amount, bool battery_backed):
        if battery_backed:
            self.save_file = fopen(file_name, "rb")
            if self.save_file:
                # load save data
                printf("Loading %x bytes of save data\n", RAM_amount * 0x2000)
                fseek(self.save_file, 0, SEEK_SET)
                fread(self.RAM, RAM_amount * 0x2000, 1, self.save_file)
                fclose(self.save_file)
            self.save_file = fopen(file_name, "wb+")  # open file for dumping
        else:
            self.save_file = NULL
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

        for i in range(4):
            self.mem.fast_read_MMAP[i]     = &self.ROM[0][i << 12]
            self.mem.fast_read_MMAP[4 + i] = &self.ROM[1][i << 12]

        for i in range(0x2000):
            self.mem.MMAP[0xa000 + i] = MakeUnused()
        self.disable_RAM()
    
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

    cdef void dump_save(MAPPER self) nogil:
        if self.save_file:
            printf("Dumping save\n")
            fseek(self.save_file, 0, SEEK_SET)
            fwrite(self.RAM, self.RAM_amount * 0x2000, 1, self.save_file)

    cdef void close(MAPPER self) nogil:
        self.dump_save()
        if self.save_file:
            fclose(self.save_file)

    cdef void enable_RAM(MAPPER self) nogil:
        self.mem.fast_read_MMAP[0xa]  = &self.RAM[self.RAM_bank][0]
        self.mem.fast_read_MMAP[0xb]  = &self.RAM[self.RAM_bank][0x1000]
        self.mem.fast_write_MMAP[0xa] = &self.RAM[self.RAM_bank][0]
        self.mem.fast_write_MMAP[0xb] = &self.RAM[self.RAM_bank][0x1000]

    cdef void disable_RAM(MAPPER self) nogil:
        self.mem.fast_read_MMAP[0xa]  = NULL
        self.mem.fast_read_MMAP[0xb]  = NULL
        self.mem.fast_write_MMAP[0xa] = NULL
        self.mem.fast_write_MMAP[0xb] = NULL