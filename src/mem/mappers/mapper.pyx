from src.mem.mem cimport MakeComplexWrite
from libc.stdio cimport fopen, fclose, FILE, fread, fwrite, fseek, printf, SEEK_END, SEEK_SET, ftell


cdef inline void write_ROM(MEM mem, unsigned short address, unsigned char value) nogil:
    # printf("MBC write %02x to %04x\n", value, address)
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
