import pandas as pd
import load_data


def kilo_watt_calculator(df):
    """
    this function will be called by main()
    it has one argument "df"
    it receives a dataframe
    df will depend upon what kind of grouping criteria is used in main function
    """
    source_tags = ["Battery", "DG", "Solar"]
    rows = []

    for source_tag in source_tags:
        # as str.contains() return a series of booleans i used it as a mask to get the values
        # for kw calculation
        mask = df["Source Tag"].str.contains(source_tag, case=False)

        # reps is how many times a source tag appear
        reps = df["Source Tag"].str.contains(source_tag, case=False).sum()
        run_hours = (reps * (3 / 60)).round(2)

        # using mask to get the values for formula of kw
        if source_tag == "Battery":
            kw = round(
                (
                    df.loc[mask, "Battery Total Current"]
                    * df.loc[mask, "Total Voltage"]
                    / 1000
                ).mean(),
                2,
            )

        elif source_tag == "DG":
            kw = round(
                (
                    df.loc[mask, "Total Load Current"]
                    * df.loc[mask, "Total Voltage"]
                    / 1000
                ).mean(),
                2,
            )

        elif source_tag == "Solar":
            kw = round(
                (
                    df.loc[mask, "Solar Output Current"]
                    * df.loc[mask, "Total Voltage"]
                    / 1000
                ).mean(),
                2,
            )

        if run_hours > 0:
            rows.append(
                {
                    "site_code": df["Site Code"].iloc[0],
                    "hour_window": df.name,
                    "source": source_tag,
                    "run_hours": run_hours,
                    "kw": kw,
                }
            )

    return pd.DataFrame(rows)


# Note: i would have encapsulate the function in a class but task requires that file should produce output
# on running
def main():
    """
    this function will calculate kilo watt
    it will load the data using load_data.py
    it will apply kilo watt calculator to the dataframe
    """
    df = load_data.load_dataset("Data_Engineering_Challenge.csv")
    result = df.groupby("Hourly_Timestamp").apply(kilo_watt_calculator)
    result.reset_index(drop=True, inplace=True)
    result.to_csv("Task3_Output.csv", index=False)


# testing the function
if __name__ == "__main__":
    main()
