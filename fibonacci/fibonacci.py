# Can you generate efficient Python code for it?
# ChatGPT said:
# Of course!
# Here’s a very efficient Python version for calculating the n-th Fibonacci number, designed to be fast and clean — no recursion, just iteration.

def fibonacci(n: int) -> int:
    if n == 0:
        return 0
    elif n == 1:
        return 1

    a, b = 0, 1
    for _ in range(2, n + 1):
        a, b = b, a + b

    return b

# Example usage
if __name__ == "__main__":
    n = 10
    print(f"Fibonacci({n}) =", fibonacci(n))


# run it as "python3 fibonacci.py"
