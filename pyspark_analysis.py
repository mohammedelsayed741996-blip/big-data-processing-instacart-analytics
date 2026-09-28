from pyspark.sql import SparkSession

# Initialize Spark Session
spark = SparkSession.builder.appName("InstacartAnalysis").getOrCreate()

# Load HDFS CSV files into Spark DataFrames
orders_df = spark.read.csv("hdfs:///user/cloudera/instacart/order_products_prior/", header=True, inferSchema=True)
products_df = spark.read.csv("hdfs:///user/cloudera/instacart/products/", header=True, inferSchema=True)
departments_df = spark.read.csv("hdfs:///user/cloudera/instacart/departments/", header=True, inferSchema=True)

# Execute In-Memory DAG Aggregation
result = orders_df.join(products_df, "product_id") \
    .join(departments_df, "department_id") \
    .groupBy("department") \
    .count() \
    .orderBy("count", ascending=False)

# Display Top 10 Departments
result.show(10)
