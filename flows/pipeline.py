from prefect import flow


@flow(log_prints=True)
def hello(user_input: str = "World"):
    print(f"Hello {user_input}!")


if __name__ == "__main__":
    hello()
