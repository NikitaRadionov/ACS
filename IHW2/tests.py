f = lambda x: 2 * x ** 4 - 6 * x ** 3 + 3 * x ** 2 - 2 * x + 1

def half_division(e):
    if e > 0.001 or e < 0.00000001:
        return "Incorrect accuracy"
    l = 0
    r = 1

    while r - l > e:
        c = (l + r) / 2
        if f(l) * f(c) < 0:
            r = c
        else:
            l = c

    c = (l + r) / 2
    return c

def run_test_cases(test_cases):
    i = 1
    for test_case in test_cases:
        e, answer = test_case
        c = half_division(e)
        if c == answer:
            print(f"{i}. Test passed: {c} == {answer}")
        else:
            print(f"{i}. Test failed: {c} != {answer}")
        i += 1

def manual():
    e = float(input())
    c = half_division(e)
    print(c)

test_casess = [
    (0.00000001, 0.5472415275871754),
    (0.0001, 0.547271728515625),
    (0.001, 0.54736328125),
    (0.01, "Incorrect accuracy"),
    (0.000000001, "Incorrect accuracy"),
]


if __name__ == "__main__":
    run_test_cases(test_casess)