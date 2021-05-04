from libcpp cimport bool

cdef extern from "scheduler.h":
    cdef cppclass event_t:
        event_t()
        event_t(void* caller, bool (*callback)(void* caller, event_t* event, scheduler_t* scheduler))
        event_t(void* caller, bool (*callback)(void* caller, event_t* event, scheduler_t* scheduler), unsigned long long time)

    cdef cppclass scheduler_t:
        scheduler_t(unsigned long long* timer)
        event_t* MakeEvent(void* caller, bool (*callback)(void* caller, event_t* event, scheduler_t* scheduler))
        event_t* MakeEvent(void* caller, bool (*callback)(void* caller, event_t* event, scheduler_t* scheduler), unsigned long long time)
        void AddEvent(event_t* event)
        void AddEventAfter(event_t* event, unsigned long long dt)
        void RemoveEvent(event_t* event)
        void RescheduleEvent(event_t* event, unsigned long long new_t)
        bool DoEvents()
        bool ShouldDoEvents()