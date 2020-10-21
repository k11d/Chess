import time


def call_timer(log_output):
    def outter(Func):
        def inner(*args, **kwargs):
            t0 = time.time()
            ret = Func(*args, **kwargs)
            dt = time.time() - t0
            log_output.log(Func.__name__, dt)
            return ret
        return inner
    return outter

class TimingData:
    tables = []

    def __init__(self) -> None:
        self.table = {}
        self.tables.append(self.table)

    def log(self, funcname, dt):
        print(f"{funcname} - {dt} seconds.")
        try:
            self.table[funcname].append(dt)
        except KeyError:
            self.table[funcname] = [dt]


if __name__ == "__main__":
    
    timing = TimingData()

    @call_timer(timing)
    def hello(name="unknown"):
        print("Hello world")
        time.sleep(1)
        print("Done waiting 1second")

    print(timing)
    hello("Billly")
    print(timing)
    hello()
    print(timing)
