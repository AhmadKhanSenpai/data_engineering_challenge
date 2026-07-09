import pandas as pd

data_valid = {
    "Site Code": str,
    "Source Tag": str,
    "Solar Output Current": float,
    "Total Load Current": float,
    "Battery Total Current": float,
    "Total Voltage": float,
}


# creating a function that reads, validate and clean the data
def load_dataset(path: str) -> pd.DataFrame:
    # reading the data
    df = pd.read_csv(path)

    # removing leading and trailing spaces
    df = df.apply(lambda col: col.str.strip() if col.dtype == "object" else col)
    # converting to datetime object
    df["Timestamp"] = pd.to_datetime(df["Timestamp"])

    # validating the datatypes
    for col, dtypes in data_valid.items():
        df[col] = df[col].astype(dtypes)

    if df.shape[0] != 480:
        raise Exception("The data is not valid")

    # i am writing this here because the task2 and task 3 both are expecting hourlty timestamp
    df["Hourly_Timestamp"] = df["Timestamp"].dt.floor("h")

    return df


# lets check the function now
if __name__ == "__main__":
    df = load_dataset("Data_Engineering_Challenge.csv")
    print(df.head())
    print("---------------------------")
    print(df.dtypes)
    print("---------------------------")
    print(df.shape)
