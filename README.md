# gratium-token
Дефляционный токен Gratium (GRA) для поощрения взаимной помощи
# Gratium (GRA)

> 💠 Дефляционный токен взаимопомощи  
> 💠 A deflationary token of mutual aid

---

## 🇷🇺 Описание проекта

**Gratium (GRA)** — это токен, в котором каждый держатель становится частью системы справедливой и прозрачной взаимопомощи.

Каждый месяц:

- 🔥 25% сгорают у тех, кто **не отправил 10%** от своего максимального баланса за месяц
- 🎁 Активные участники получают **награды**
- ⏳ Те, кто только получил токены (например, через покупку), получают **отсрочку** — у них есть 10 дней до сгорания
- 💡 Система полностью автоматизирована (GitHub Actions + смарт-контракт)
- 📉 Количество токенов **никогда не увеличивается**

**Контракт неизменяемый**, новые токены выпускать **невозможно**.

---

## 🇬🇧 Project Description

**Gratium (GRA)** is a token designed to build a transparent and fair ecosystem of mutual support.

Each month:

- 🔥 25% are burned from holders who **did not send 10%** of their max monthly balance
- 🎁 Active users receive **rewards**
- ⏳ New holders (e.g., who bought tokens) have a **10-day grace period** before burn applies
- 💡 Entire system is automated via **GitHub Actions and smart contracts**
- 📉 No new tokens are ever minted — deflationary by design

**The contract is immutable.** No admin privileges. No supply increase.

---

## 📊 Токеномика / Tokenomics

| Категория | % | Примечание |
|-----------|----|------------|
| Airdrop   | 30% | Стартовое распространение |
| Rewards Pool (Auto) | 5% | Только для автоматической рассылки |
| Rewards Pool (Manual) | 10% | По усмотрению команды |
| Team      | 10% + 10% заморожено | Стимул на развитие |
| Liquidity | 5% | DEX пул |
| Development Reserve | 10% | Технические нужды |
| Burn Logic | Авто | До 25% ежемесячно у неактивных |

---

## ⚙️ Автоматизация / Automation

Реализовано через GitHub Actions:

- `snapshotEligible()` — фиксирует активных
- `burnInactive()` — сжигает 25% у неактивных
- `batchDistribute()` — рассылает награды

> Запуск 17 и 18 числа каждого месяца

Требуется пополнение автоматического кошелька MATIC (до 50$ в месяц на газ).

---

## 🌐 Контакты / Contacts

- Web: (скоро)
- Telegram: (добавим позже)
- Wallet для автоматизации: `0x1f02750c7fdf70048da335154a74f1e839217ca7`

---

## 🛡 Надёжность / Trust

- 📌 Контракт Immutable
- 🚫 Minting запрещён
- 🔐 DAO выключено по умолчанию
- ✅ Полностью open-source

---

## 🧪 Deployment (for devs)

- Deploy on Polygon (Mumbai for testnet / Mainnet)
- Use `GratiumToken.sol`
- Set pools and system wallet in constructor
- All interaction via verified methods (burn, snapshot, distribute)

---

## 🔗 Лицензия / License

MIT (при желании добавим)
