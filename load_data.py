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
    df = pd.read_csv(path)  # reading the data

    df = df.apply(
        lambda col: col.str.strip() if col.dtype == "object" else col
    )  # removing spaces if any

    df["Timestamp"] = pd.to_datetime(
        df["Timestamp"], utc=True
    )  # converting to datetime object with utc

    for col, dtypes in data_valid.items():
        df[col] = df[col].astype(dtypes)  # validating the data

    try:
        if df.shape[0] == 480:
            pass
    except ValueError:
        print("number of rows is not 480")

    return df


# lets check the function now
if __name__ == "__main__":
    df = load_dataset("Data_Engineering_Challenge.csv")
    print(df.head())
    print("---------------------------")
    print(df.dtypes)
    print("---------------------------")
    print(df.shape)
