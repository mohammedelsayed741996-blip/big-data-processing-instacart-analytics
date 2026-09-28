import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score, classification_report, confusion_matrix

# Load Data
orders = pd.read_csv("orders.csv")
prior = pd.read_csv("order_products_prior.csv")

# Feature Engineering: User-Product Interaction Metrics
user_product_counts = prior.merge(orders[['order_id', 'user_id']], on='order_id')
features = user_product_counts.groupby(['user_id', 'product_id']).agg(
    times_ordered=('reordered', 'count'),
    times_reordered=('reordered', 'sum'),
    avg_cart_position=('add_to_cart_order', 'mean')
).reset_index()

features['reorder_ratio'] = features['times_reordered'] / features['times_ordered']

# Define Features (X) and Target (y)
X = features[['times_ordered', 'times_reordered', 'avg_cart_position', 'reorder_ratio']]
y = (features['reorder_ratio'] > 0.5).astype(int)

# Train-Test Split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Feature Scaling
scaler = StandardScaler()
X_train = scaler.fit_transform(X_train)
X_test = scaler.transform(X_test)

# Train Random Forest Ensemble Classifier
model = RandomForestClassifier(n_estimators=100, max_depth=10, random_state=42)
model.fit(X_train, y_train)

# Predict & Evaluate
y_pred = model.predict(X_test)
print(f"Accuracy: {accuracy_score(y_test, y_pred):.4f}")
print("\nClassification Report:\n", classification_report(y_test, y_pred))
