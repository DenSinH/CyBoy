from src.mem.mem cimport MEM


cdef class MAPPER:
    # parent class for all mappers
    cdef:
        unsigned char[128][0x4000] ROM  # support at most 128 banks (2MB)
        unsigned char[16][0x2000] RAM
        unsigned char ROM_amount, RAM_amount  # amount of banks
        unsigned char ROM_bank, RAM_bank
        unsigned char banking_mode

        MEM mem

    cdef void write8(MAPPER self, unsigned short address, unsigned char value) nogil

    cdef void init_mmap(MAPPER self) nogil

    cdef void load_rom(MAPPER self, str file_name)

    cdef void enable_RAM(MAPPER self) nogil

    cdef void disable_RAM(MAPPER self) nogil
