import time

def call_timer(log_output):
    def outter(Func):
        def inner(*args, **kwargs):
            t0 = time.time()
            ret = Func(*args, **kwargs)
            dt = time.time() - t0
            print(f"{Func.__name__} ran in {dt} seconds.")
            try:
                log_output[Func.__name__].append(dt)
            except:
                log_output[Func.__name__] = [dt]
            return ret
        return inner
    return outter


if __name__ == "__main__":
    timing = {}

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
