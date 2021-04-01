import pandas as pd


def simple_table(csf_file="", output=""):
    csv_file = pd.read_csv(csf_file)
    csv_file.to_html(output)
    # html_file = csv_file.to_html()
    return True

if __name__ == "__main__":
    simple_table(r"testresult/taurus-result-songshanhu-test-overview.csv", r"testresult/taurus-result-songshanhu-test-overview.html")