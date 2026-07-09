import pandas as pd
import load_data


def run_hours(df):
    """
    this function will be called by main()
    it has one argument "df"
    it receives a dataframe
    df will depend upon what kind of grouping criteria is used in main function
    """
    source_tags = ["Battery", "DG", "Solar"]
    rows = []

    for source_tag in source_tags:
        reps = (
            df["Source Tag"].str.contains(source_tag, case=False).sum()
        )  # reps is how many times a source tag appear
        run_hours = (reps * (3 / 60)).round(2)

        # now we check if run_hours are greater than 0 and then append the dict to rows
        if run_hours > 0:
            rows.append(
                {
                    "site code": df["Site Code"].iloc[0],
                    "hour window": df.name,
                    "source": source_tag,
                    "run_hours": run_hours,
                }
            )

    return pd.DataFrame(rows)


# Note: I am making this function becasue task requires it, usually we need a function that can also
# be applied on similar datasets like this one
def main():
    """
    this function will calculate run hours
    it will load the data using load_data.py
    it will apply run hours calculator to the dataframe
    """
    df = load_data.load_dataset("Data_Engineering_Challenge.csv")
    result_df = df.groupby("Hourly_Timestamp").apply(run_hours)
    result_df.reset_index(drop=True, inplace=True)
    result_df.to_csv("Task2_Output.csv", index=False)


# testing the function
if __name__ == "__main__":
    main()
