cimport cython
from libcpp cimport bool
from libc.stdio cimport printf

include "./IO.pxi"
cdef class MEM

ctypedef unsigned char (*read_callback)(MEM mem, unsigned short address) nogil
ctypedef void (*write_callback)(MEM mem, unsigned short address, unsigned char value) nogil


cdef union read_ptr_t:
    unsigned char* data
    read_callback callback

cdef union write_ptr_t:
    unsigned char* data
    write_callback callback

cdef packed struct MemoryEntry:
    read_ptr_t read_ptr
    write_ptr_t write_ptr
    
    bool read
    bool write

cdef MemoryEntry MakeRW(unsigned char* data) nogil
cdef MemoryEntry MakeROM(unsigned char* data) nogil
cdef MemoryEntry MakeUnused() nogil
cdef MemoryEntry MakeIO(read_callback read, write_callback write) nogil


cdef struct IO_REGS:
    unsigned char JOYPAD  # note: not the register, just a mask!
    unsigned char JOYP

    unsigned char DIV
    unsigned char TIMA
    unsigned char TMA
    unsigned char TAC
    unsigned int TIMA_timer
    unsigned int TIMA_limit

    unsigned char LY, LYC
    unsigned char LCDC
    unsigned char STAT
    unsigned char SCY, SCX
    unsigned char IE, IF_  # IF is a reserved keyword in cython

@cython.final
cdef class MEM:
    cdef:
        unsigned char[0x100]  BOOT 
        unsigned char[0x4000] ROM0 
        unsigned char[0x4000] ROM1 
        unsigned char[0x2000] VRAM 
        unsigned char[0x2000] ERAM 
        unsigned char[0x1000] WRAMlo 
        unsigned char[0x1000] WRAMhi 

        unsigned char[0xa0] OAM
        unsigned char[0x7f] HRAM

        MemoryEntry[0x10000] MMAP

        IO_REGS IO
        void (*interrupt_cpu)(void* cpu) nogil
        void* cpu

    cdef inline void bind_cpu(MEM self, void (*interrupt_cpu)(void* cpu) nogil, void* cpu):
        self.interrupt_cpu = interrupt_cpu
        self.cpu = cpu

    cdef inline void set_STAT_mode(MEM self, unsigned char mode) nogil:
        self.IO.STAT = (self.IO.STAT & 0xfc) | mode
        if mode < 3 and self.IO.STAT & (0x8 << mode):
            self.IO.IF_ |= INTERRUPT_STAT
            self.interrupt_cpu(self.cpu)

    cdef inline void tick(MEM self, unsigned int cycles) nogil:
        self.IO.DIV += cycles
        if self.IO.TAC & TIMA_ENABLED:
            self.IO.TIMA_timer += cycles
            if self.IO.TIMA_timer > self.IO.TIMA_limit:
                self.IO.TIMA_timer -= self.IO.TIMA_limit
                self.IO.TIMA += 1
                if self.IO.TIMA == 0:
                    self.IO.TIMA = self.IO.TMA
                    self.IO.IF_ |= INTERRUPT_TIMER
                    self.interrupt_cpu(self.cpu)

    cdef inline unsigned char read8(MEM self, unsigned short address) nogil:
        cdef MemoryEntry entry = self.MMAP[address]

        if entry.read:
            return entry.read_ptr.data[0]
        elif entry.read_ptr.callback is not NULL:
            return entry.read_ptr.callback(self, address)  # todo: address is for debugging
        return 0xff  # default for bad reads

    cdef inline unsigned short read16(MEM self, unsigned short address) nogil:
        cdef unsigned short value
        value = self.read8(address)
        value |= (<unsigned short>self.read8(address + 1)) << 8
        return value

    cdef inline void write8(MEM self, unsigned short address, unsigned char value) nogil:
        cdef MemoryEntry entry = self.MMAP[address]

        if entry.write:
            entry.write_ptr.data[0] = value
        elif entry.write_ptr.callback is not NULL:
            entry.write_ptr.callback(self, address, value)  # todo: address is for debugging

    cdef inline void write16(MEM self, unsigned short address, unsigned short value) nogil:
        self.write8(address, <unsigned char>value)
        self.write8(address + 1, <unsigned char>(value >> 8))