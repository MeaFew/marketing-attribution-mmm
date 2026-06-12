.PHONY: setup preprocess eda mmm attribution attribution-simulated optimize dashboard test verify clean

# ============================================================
# Marketing Attribution & Budget Optimization
# ============================================================

setup:
	pip install -r requirements.txt

preprocess:
	python scripts/preprocess.py

eda:
	jupyter notebook notebooks/01_eda.ipynb

mmm:
	python scripts/mmm_model.py

attribution:
	python scripts/preprocess_criteo.py
	python scripts/multi_touch_attribution.py

attribution-simulated:
	python scripts/generate_touchpoints.py
	python scripts/multi_touch_attribution.py --touchpoints data/processed/simulated_touchpoints.parquet --journeys data/processed/simulated_journeys.parquet

optimize:
	python scripts/budget_optimizer.py

dashboard:
	streamlit run dashboard/app.py

test:
	pytest tests/ -v

verify: lint format-check test audit

all: preprocess mmm attribution optimize

clean:
	rm -rf data/processed/*.parquet
	rm -rf data/processed/*.duckdb
	rm -rf reports/images/*.png
	find . -type d -name "__pycache__" -exec rm -rf {} +

# === Quality gates (extended) ===

lint:
	ruff check scripts/ dashboard/ tests/ --ignore E501,E402,N803,N806

# === Quality gates (extended) ===

format:
	ruff format scripts/ dashboard/

format-check:
	ruff format --check scripts/ dashboard/

audit:
	python scripts/audit_consistency.py
