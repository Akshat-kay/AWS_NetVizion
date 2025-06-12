```markdown
# 🛰️ AWS NetVizion — Real-Time Network Telemetry Ingestion & Forecasting

## 🚀 Overview

AWS NetVizion is a full-stack, cloud-native project that simulates, ingests, enriches, stores, visualizes, and forecasts network telemetry data in real-time. Built using **AWS Services**, **Terraform**, **Python**, and **Prophet**, this project demonstrates modern observability and predictive analytics pipelines.

---

## 🗂️ Project Structure

```

## 🧱 Architecture Overview

```text
+------------------------------+
|  Simulated Traffic Generator |
|        (Python Script)       |
+--------------+---------------+
               |
               v
    +------------------------+
    | Amazon Kinesis Stream  |
    +-----------+------------+
                |
                v
      +--------------------+
      |   AWS Lambda        |
      |  (Enrich Metadata)  |
      +---------+-----------+
                |
                v
      +--------------------+
      | Amazon Timestream  |
      | (Time-series DB)   |
      +---------+----------+
                |
        +-------+--------+
        |                |
        v                v
+---------------+   +--------------------+
|    Grafana     |   |  Jupyter Notebook  |
|   (Live View)  |   |   + Prophet Model  |
+---------------+   +--------------------+
                        |
                        v
                +-------------------+
                | Forecast CSV (S3) |
                +-------------------+
                        |
                        v
                 (Optional: Athena)

```

---

## 🧱 Architecture Overview

```

┌────────────────────────────┐
│ Simulated Telemetry (Python) ─────────┐
└────────────────────────────┘          │
▼
┌────────────────────┐
│ Amazon Kinesis     │
└────────────────────┘
│
▼
┌────────────────────┐
│ AWS Lambda         │
│ (Data Enrichment)  │
└────────────────────┘
│
▼
┌────────────────────┐
│ Amazon Timestream  │
└────────────────────┘
│
┌─────────────────┴──────────────────┐
│                                    │
▼                                    ▼
┌──────────────────┐                ┌─────────────────────────┐
│    Grafana       │                │  Jupyter Notebook       │
│ (Live Dashboard) │                │ (Forecast via Prophet)  │
└──────────────────┘                └──────────┬──────────────┘
│
▼
┌────────────────────┐
│ Export CSV Forecast│
│ to S3              │
└────────────────────┘
│
(OPTIONAL: Query via Athena)

````

---

## ✅ Features

- 🌀 Real-time telemetry generator using Python
- 📡 Ingestion with Amazon Kinesis
- 🧠 Lambda function enriches data (region, service) and writes to Timestream
- 📈 Grafana dashboards to visualize live metrics
- 🔮 Forecasting with Prophet in Jupyter Notebook
- ☁️ Optional S3 + Athena pipeline for historical forecast analysis

---

## 🧰 Tech Stack

| Category          | Tools/Services                         |
|------------------|----------------------------------------|
| Cloud            | AWS (Kinesis, Lambda, Timestream, S3, Athena, IAM) |
| Infrastructure   | Terraform                              |
| Data Processing  | Python, Boto3                          |
| Forecasting      | Facebook Prophet                       |
| Visualization    | Grafana, Jupyter Notebook              |

---

## ⚙️ Getting Started

### 1. 🔐 AWS CLI & IAM Setup
- Create an IAM user with `Programmatic access`
- Configure your AWS CLI:
```bash
aws configure --profile netvizion
````

### 2. 🛠️ Deploy Infrastructure

```bash
cd terraform/
terraform init
terraform apply
```

This provisions Kinesis, Timestream, and the Lambda role.

### 3. 🧠 Deploy the Lambda Processor

Lambda function is defined in `processor/lambda_function.py` and attached via Terraform.

### 4. 🧪 Run the Traffic Generator

```bash
cd ingestor/
pip install boto3
python generator.py
```

### 5. 📊 Set Up Grafana for Live View

* Add Amazon Timestream as a data source
* Use query like:

```sql
SELECT measure_name, measure_value::bigint, time
FROM "netvizion_db"."netvizion_table"
ORDER BY time DESC
```

### 6. 🔮 Forecast with Prophet

```bash
cd forecast/
jupyter notebook
# Open forecast_model.ipynb and run cells
```

### 7. ☁️ Export Forecast to S3 (Optional)

* Save results as CSV
* Upload to S3
* Optionally query with Athena in Jupyter Notebook only

---

## 📸 Screenshots

### 📊 Real-Time Telemetry (Grafana)

![Grafana Live Dashboard](grafanadashboard.png)

### 🔮 Forecasted Network Traffic (Prophet in Jupyter)

![Forecasted Traffic](forecast.png)

---

## 📌 Credits

Created by \Akshat
Built with ❤️ using AWS, Terraform, Python, and Grafana

---

## 📜 License

This project is open-sourced under the MIT License.

```


