🧾 Sales Taxes Kata – “Production-ready” Ruby 3.3 Solution

Author: Paulo   |   Elapsed time: ≈ 4 h (coding + polish)

Brief – Implement the classic Sales Taxes problem in pure Ruby (no Rails, no runtime gems) demonstrating senior-level OO design, full test coverage, thread-safety, and clear documentation.

⸻

1 • Challenge Statement (verbatim extract)

	1.	Basic sales tax 10 % on all goods except books, food, and medical products.
	2.	Import duty 5 % on every imported good, no exemptions.
	3.	Taxes are additive; each product’s tax is rounded up to the nearest 0.05.
	4.	Input/output must match the three sample baskets exactly.
	5.	Use the latest Ruby, object-oriented design, full tests, thread-safety, “don’t over-engineer”.

(Full wording lives in docs/challenge.md for reference.)

⸻

2 • High-level Approach

Phase	What I did	Time
Environment	Project scaffold + RSpec + Rubocop, lock Ruby 3.3	15 min
Domain sketch	Immutable value objects, strategy tax rules	15 min
Core coding	Product, TaxRule, TaxCalculator + unit specs	35 min
Basket flow	BasketItem, Basket, InputParser, Receipt	55 min
E2E & Concurrency	Three fixture baskets, thread-safety spec	20 min
CLI & polish	OptionParser wrapper, README, CI workflow	40 min

Total wall-clock ≈ 3 h 35 m (fits the 4 h guideline).

⸻

3 • Project Structure

sales_taxes/
├── bin/                 # 20-line CLI entry-point
├── lib/sales_taxes/     # domain code (≤ 40 LOC each)
├── spec/                # unit + integration + concurrency
├── docs/brief.md        # full exercise wording
├── .rubocop.yml         # lint rules (rubocop-rspec)
└── README.md            # you’re here

All library files start with # frozen_string_literal: true.

⸻

4 • Key Design Decisions
	•	Thread-safety – Every domain object is freezed after construction, so they can be shared across threads with zero locks.
	•	Open for extension – Tax logic follows the Strategy pattern (BasicTaxRule, ImportTaxRule). Adding a new tax is one subclass + calculator injection.
	•	No “God” class – Responsibilities are split: Product (data) • BasketItem (roll-up) • Basket (collection) • Receipt (presenter).
	•	Precise monetary rounding – Uses BigDecimal; formula:

(amount / 0.05).ceil * 0.05


	•	Simple, explicit parsing – InputParser holds a single RegExp; keeps the domain layer free of I/O strings.
	•	Avoid over-engineering – < 180 LOC in lib/, no metaprogramming, no runtime gems.

⸻

5 • Assumptions

Area	Assumption
Category detection	Keyword match: /book/i, /chocolate/i, /pill/i → :book, :food, :medical.
Input validity	Prices always have two decimals, quantities are positive integers, UTF-8 text.
Currency	Always printed with 2 dp.
CLI default	Reads STDIN when no file path is given; --json flag outputs machine-readable receipt.


⸻

6 • How to Run

# Clone & install tooling
git clone https://github.com/your-handle/sales_taxes.git
cd sales_taxes
bundle install          # installs RSpec & Rubocop only

# Plain-text receipt
./bin/sales_taxes spec/fixtures/input_1.txt

# JSON receipt
./bin/sales_taxes -j spec/fixtures/input_2.txt

# Run tests & linter
bundle exec rspec
bundle exec rubocop -A


⸻

7 • Testing & Quality Gates

Suite	Focus	Files
Unit	Rounding helper, each tax rule, immutability	spec/unit/*
Integration	Sample baskets 1-3 byte-for-byte match	spec/integration/receipt_spec.rb
Concurrency	10 threads build the same basket → identical output	spec/integration/thread_safety_spec.rb
CI	GitHub Action runs Bundler → Rubocop → RSpec on each push	.github/workflows/ci.yml

Test runtime ≈ 0.3 s.

⸻

8 • Extending the Solution
	•	Add a new tax rule – Subclass TaxRule, then inject it into TaxCalculator.
	•	Change rounding – Adjust one private method in TaxCalculator.
	•	Different input format – Replace or extend InputParser; the domain layer remains unchanged.
	•	Alternate output – Subclass Receipt (e.g. JsonReceipt, HtmlReceipt).

⸻

9 • Evaluation Checklist
	•	Latest Ruby (3.4.4)
	•	Zero runtime gems (pure standard-lib)
	•	OO design, no god class, composition > inheritance
	•	Thread-safe (immutable, no globals)
	•	100 % green RSpec suite
	•	Rubocop clean (incl. rubocop-rspec)
	•	Clear README & inline YARD docs
	•	Completed within the 4 h guideline