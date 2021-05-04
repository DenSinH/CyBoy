#include <functional>
#include <queue>
#include <array>

#define ALWAYS_INLINE inline __attribute__((always_inline))

class scheduler_t;
class event_t;

// returns whether CPU was affected
#define SCHEDULER_CALLBACK(name) bool name(void* caller, event_t* event, scheduler_t* scheduler)

class event_t {
public:
    constexpr event_t() :
        caller(nullptr),
        callback(nullptr) {

    }

    constexpr event_t(void* const _caller, SCHEDULER_CALLBACK((*_callback))) :
        caller(_caller),
        callback(_callback) {

    }

    constexpr event_t(void* const _caller, SCHEDULER_CALLBACK((*_callback)), unsigned long long _time) :
        event_t(_caller, _callback) {
        time = _time;
    }

    SCHEDULER_CALLBACK((*callback));

    void* caller;
    unsigned long long time = 0;
    bool active = false;   // signifies if event is in the scheduler or not
};

/*
 * Idea: make a heap structure, add events sorted on time, remove events sorted on time, then check if callback is equal
 * (function pointers can be compared anyway)
 * */

/*
 * C++ implementation using std::heap
 * */

static auto cmp = [](event_t* left, event_t* right) {
    return left->time > right->time;
};

template<
        typename T,
        class Container=std::vector<T>,
        class Compare=std::less<typename Container::value_type>
>
class deleteable_priority_queue : public std::priority_queue<T, Container, Compare> {
public:

    bool remove(const T &value) {
        auto it = std::find(this->c.begin(), this->c.end(), value);
        if (it != this->c.end()) {
            this->c.erase(it);
            std::make_heap(this->c.begin(), this->c.end(), this->comp);
            return true;
        } else {
            return false;
        }
    };

    void map(void (*f)(T*)) {
        for (auto it = this->c.begin(); it != this->c.end(); it++) {
            f(&(*it));
        }
    }
};

// we know that there is always _something_ in the queue
class scheduler_t {
private:
    friend class Initializer;
    // event to put in queue to make sure it is not empty
    event_t infty = event_t(
        this,
        [] (void* caller, event_t* event, scheduler_t* scheduler) -> bool {
            *(scheduler->timer) -= 0x7000'0000;
            scheduler->queue.map([](event_t** value) {
                (*value)->time -= 0x7000'0000;
            });

            // schedule at 0x7000'0000 again
            scheduler->AddEvent(event);
            return false;
        },
        0x7000'0000
    );

    unsigned int number_of_events = 0;
    std::array<event_t, 64> events = {};
    deleteable_priority_queue<event_t*, std::vector<event_t*>, decltype(cmp)> queue;

public:
    unsigned long long* const timer;
    unsigned long long top;

    explicit scheduler_t(unsigned long long* _timer) :
            timer(_timer) {
        this->Reset();
    }

    constexpr event_t* MakeEvent(void* caller, SCHEDULER_CALLBACK((*callback))) {
        events[number_of_events] = event_t(caller, callback);
        return &events[number_of_events++];
    }

    constexpr event_t* MakeEvent(void* caller, SCHEDULER_CALLBACK((*callback)), unsigned long long time) {
        events[number_of_events] = event_t(caller, callback, time);
        return &events[number_of_events++];
    }

    void Reset() {
        // clear queue (fill queue with initial event)
        queue = {};
        top = 0xffff'ffff'ffff'ffff;
    }

    void AddEvent(event_t* event) {
        if (!event->active) {
            event->active = true;
            queue.push(event);
#ifdef min
            top = min(top, event->time);
#else
            top = std::min(top, event->time);
#endif
        }
    }

    void AddEventAfter(event_t* event, unsigned long long dt) {
        if (!event->active) {
            event->time = *timer + dt;
            event->active = true;
            queue.push(event);
#ifdef min
            top = min(top, event->time);
#else
            top = std::min(top, event->time);
#endif
        }
        else {
            RemoveEvent(event);
            AddEventAfter(event, dt);
        }
    }

    void RemoveEvent(event_t* event) {
        queue.remove(event);
        event->active = false;

        // top might have changed
        top = queue.top()->time;
    }

    void RescheduleEvent(event_t* event, unsigned long long new_time) {
        if (event->active) {
            RemoveEvent(event);
        }
        event->time = new_time;
        AddEvent(event);
    }

    bool DoEvents() {
        event_t* first = queue.top();
        bool cpu_affected = false;
        while (first->time <= *timer) {
            first->active = false;

            queue.pop();
            cpu_affected |= first->callback(first->caller, first, this);

            // new first element
            first = queue.top();
        }
        top = first->time;
        return cpu_affected;
    }

    ALWAYS_INLINE unsigned long long PeekEvent() const {
        return top;
    }

    ALWAYS_INLINE bool ShouldDoEvents() const {
        return top <= *timer;
    }
};