# 🧾 Sales Taxes Code Challenge – Solution

**Author:** Paulo Langer | paulofabiano@gmail.com

**Brief:** Implement the Sales Taxes problem in pure Ruby (no Rails, no runtime gems) demonstrating OO design, full test coverage, thread-safety, and clear documentation.

---

## 1. Challenge Statement (verbatim extract)

1. Basic sales tax 10% on all goods except books, food, and medical products.
2. Import duty 5% on every imported good, no exemptions.
3. Taxes are additive; each product's tax is rounded up to the nearest 0.05.
4. Input/output must match the three sample baskets exactly.
5. Use the latest Ruby, object-oriented design, full tests, thread-safety, "don't over-engineer".

*(Full wording lives in docs/challenge.md for reference.)*

---

## 2. High-level Approach

| Phase | What I did |
|-------|------------|
| Environment | Project scaffold + RSpec + Rubocop, lock Ruby 3.4.4 |
| Domain sketch | Immutable value objects, strategy tax rules |
| Core coding | Product, TaxRule, TaxCalculator + unit specs |
| Basket flow | BasketItem, Basket, InputParser, Receipt |
| E2E & Concurrency | Three fixture baskets, thread-safety spec |
| CLI & polish | OptionParser wrapper, README |

---

## 3. Project Structure

```
sales_taxes/
├── bin/                 # CLI entry-point
├── lib/sales_taxes/     # domain code
├── spec/                # unit + integration + concurrency
├── docs/challenge.md    # full exercise wording
├── .rubocop.yml         # lint rules (rubocop-rspec)
└── README.md            # you're here
```

---

## 4. Key Design Decisions

- **Thread-safety** – Every domain object is frozen after construction, so they can be shared across threads with zero locks.
- **Open for extension** – Tax logic follows the Strategy pattern (BasicTaxRule, ImportTaxRule). Adding a new tax is one subclass + calculator injection.
- **No "God" class** – Responsibilities are split: Product (data) • BasketItem (roll-up) • Basket (collection) • Receipt (presenter).
- **Precise monetary rounding** – Uses BigDecimal; formula:

```ruby
(amount / 0.05).ceil * 0.05
```

- **Simple, explicit parsing** – InputParser holds a single RegExp; keeps the domain layer free of I/O strings.
- **Avoid over-engineering** – no metaprogramming, minimal runtime gems.

---

## 5. Assumptions

| Area | Assumption |
|------|------------|
| Category detection | Keyword match: `/book/i`, `/chocolate/i`, `/pill/i` → `:book`, `:food`, `:medical`. |
| Input validity | Prices always have two decimals, quantities are positive integers, UTF-8 text. |
| Currency | Always printed with 2 dp. |
| CLI default | Reads STDIN when no file path is given; `--json` flag outputs machine-readable receipt. |

---

## 6. How to Run

### Prerequisites
Ensure Ruby 3.4.4 is installed

### Setup
```bash
git clone https://github.com/paulofabiano/sales_taxes.git
cd sales_taxes
bundle install # installs RSpec, Rubocop, SimpleCov
```

### Usage
```bash
# Plain-text receipt
./bin/sales_taxes spec/fixtures/input_1.txt

# JSON receipt
./bin/sales_taxes -j spec/fixtures/input_2.txt

# Run tests & linter
bundle exec rspec
bundle exec rubocop
```

---

## 7. Testing & Quality Gates

| Suite | Focus | Files |
|-------|-------|-------|
| Unit | Rounding helper, each tax rule, immutability | `spec/*_spec.rb` |
| Integration | Sample baskets 1-3 byte-for-byte match | `spec/integration/receipt_spec.rb` |
| Concurrency | 10 threads build the same basket → identical output | `spec/integration/thread_safety_spec.rb` |
| Quality | Rubocop linting and RSpec testing | `bundle exec rubocop && bundle exec rspec` |

---

## 8. Extending the Solution

- **Add a new tax rule** – Subclass TaxRule, then inject it into TaxCalculator.
- **Change rounding** – Adjust one private method in TaxCalculator.
- **Different input format** – Replace or extend InputParser; the domain layer remains unchanged.
- **Alternate output** – Subclass Receipt (e.g. JsonReceipt, HtmlReceipt).

---

## 9. Evaluation Checklist

- ✅ Latest Ruby (3.4.4)
- ✅ Zero runtime gems (pure standard-lib)
- ✅ OO design, no god class, composition > inheritance
- ✅ Thread-safe (immutable, no globals)
- ✅ 100% green RSpec suite
- ✅ Rubocop clean (incl. rubocop-rspec)
- ✅ Clear README & comprehensive documentation
- ✅ Clean, maintainable implementation

---

## 10. Tooling & AI Assistance

This project was built by me, with a lot of care and curiosity. I tested everything thoroughly using RSpec and kept the code clean with RuboCop.

I used ChatGPT mostly as a rubber duck and brainstorming partner—no code was copied directly. GitHub Copilot helped here and there with autocomplete suggestions, and I also leaned on AI to polish the structure and formatting of the README. It gave me some useful insights during code reviews too.

All the design decisions, architecture, and implementation were made and refined by me. Every line of code was reviewed and committed manually.

As a fun final touch, the time tracking report was generated by AI based on the project's commit history.