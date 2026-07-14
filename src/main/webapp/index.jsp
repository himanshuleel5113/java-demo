<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AceBank — Banking Designed For Your Future</title>
    <meta name="description" content="AceBank offers secure, simple and smart internet banking — 256-bit encryption, instant transfers, and 24/7 support for a better financial tomorrow.">
    <meta name="theme-color" content="#0f2b4b">
    <link rel="canonical" href="https://acebank.example/">
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/assets/img/favicon.svg">

    <!-- Open Graph / social sharing -->
    <meta property="og:type" content="website">
    <meta property="og:title" content="AceBank — Banking Designed For Your Future">
    <meta property="og:description" content="Secure, simple and smart banking for a better tomorrow.">
    <meta property="og:site_name" content="AceBank">
    <meta name="twitter:card" content="summary_large_image">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Poppins:wght@600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/acebank.css">
</head>
<body>
<a class="skip-link" href="#main">Skip to content</a>

<div class="landing-wrap">
  <div class="landing-card">

    <!-- ============================= Top navigation ============================= -->
    <header>
      <nav class="nav" aria-label="Primary">
        <a class="brand" href="${pageContext.request.contextPath}/index.jsp" aria-label="AceBank home">
          <span class="brand-mark">
            <svg viewBox="0 0 44 44" fill="none" aria-hidden="true">
              <path d="M22 3 41 38H3L22 3Z" fill="#2563eb"/>
              <path d="M22 3 41 38H26L22 3Z" fill="#1e3a8a"/>
              <path d="M22 16 30 31H14l8-15Z" fill="#fff"/>
            </svg>
          </span>
          <span class="brand-name">AceBank</span>
        </a>

        <ul class="nav-links">
          <li><a class="active" href="#top">Home</a></li>
          <li><a href="#about">About Us</a></li>
          <li><a href="#services">Services</a></li>
          <li><a href="#features">Features</a></li>
          <li><a href="#contact">Contact</a></li>
        </ul>

        <div class="nav-actions">
          <a class="btn btn-ghost" href="${pageContext.request.contextPath}/login">Login</a>
          <a class="btn btn-blue" href="${pageContext.request.contextPath}/signup">Open Account</a>
          <button class="nav-toggle" aria-label="Toggle menu" aria-expanded="false">
            <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" aria-hidden="true"><path d="M4 6h16M4 12h16M4 18h16"/></svg>
          </button>
        </div>
      </nav>
    </header>

    <main id="main">

      <!-- ============================= Hero ============================= -->
      <section class="hero" id="top">
        <div class="hero-copy reveal">
          <h1>Banking<br>Designed For<br><span class="accent">Your Future</span></h1>
          <p class="hero-sub">Secure, simple and smart banking for a better tomorrow.</p>
          <div class="hero-actions">
            <a class="btn btn-navy btn-lg" href="${pageContext.request.contextPath}/login">Login</a>
            <a class="btn btn-ghost btn-lg" href="${pageContext.request.contextPath}/signup">Open Account</a>
          </div>
        </div>

        <div class="hero-art reveal d1" aria-hidden="true">
          <svg viewBox="0 0 600 520" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M120 120C60 190 40 300 120 360s250 90 340 20 120-210 40-290S260 40 190 70s-30 20-70 50Z" fill="#eff4ff"/>
            <path d="M96 430c-22-30-14-78 8-104 6 34 20 58 30 74-8 12-24 24-38 30Z" fill="#3b82f6"/>
            <path d="M520 430c22-30 14-78-8-104-6 34-20 58-30 74 8 12 24 24 38 30Z" fill="#2563eb"/>
            <rect x="150" y="404" width="300" height="26" rx="6" fill="#c7d6f0"/>
            <rect x="168" y="380" width="264" height="26" rx="6" fill="#d9e4f6"/>
            <g fill="#e8eefb" stroke="#cdd9f0" stroke-width="2">
              <rect x="188" y="250" width="26" height="132" rx="6"/>
              <rect x="238" y="250" width="26" height="132" rx="6"/>
              <rect x="288" y="250" width="26" height="132" rx="6"/>
              <rect x="338" y="250" width="26" height="132" rx="6"/>
              <rect x="388" y="250" width="26" height="132" rx="6"/>
            </g>
            <rect x="172" y="234" width="256" height="20" rx="6" fill="#c7d6f0"/>
            <path d="M300 150 452 232H148L300 150Z" fill="#dbe6f8"/>
            <path d="M300 150 452 232H300V150Z" fill="#c7d6f0"/>
            <text x="300" y="212" text-anchor="middle" font-family="Poppins, sans-serif" font-weight="700" font-size="26" fill="#1e3a8a">AceBank</text>
            <rect x="278" y="300" width="44" height="80" rx="8" fill="#1e3a8a"/>
            <g filter="url(#s)">
              <rect x="70" y="150" width="96" height="72" rx="16" fill="#fff"/>
              <rect x="86" y="176" width="64" height="9" rx="4" fill="#2563eb"/>
              <rect x="86" y="192" width="40" height="7" rx="3.5" fill="#bcd0f5"/>
            </g>
            <g filter="url(#s)">
              <rect x="452" y="120" width="80" height="80" rx="18" fill="#fff"/>
              <path d="M492 138l20 8v14c0 13-9 21-20 26-11-5-20-13-20-26v-14l20-8Z" fill="#2563eb"/>
              <rect x="486" y="164" width="12" height="12" rx="2.5" fill="#fff"/>
            </g>
            <g filter="url(#s)">
              <rect x="470" y="322" width="80" height="80" rx="18" fill="#fff"/>
              <path d="M510 340l22 12v6h-44v-6l22-12Z" fill="#1e3a8a"/>
              <rect x="492" y="362" width="6" height="20" fill="#2563eb"/>
              <rect x="507" y="362" width="6" height="20" fill="#2563eb"/>
              <rect x="522" y="362" width="6" height="20" fill="#2563eb"/>
              <rect x="488" y="384" width="44" height="6" rx="3" fill="#1e3a8a"/>
            </g>
            <defs>
              <filter id="s" x="0" y="0" width="600" height="520" filterUnits="userSpaceOnUse">
                <feDropShadow dx="0" dy="10" stdDeviation="12" flood-color="#1e3a8a" flood-opacity="0.14"/>
              </filter>
            </defs>
          </svg>
        </div>
      </section>

      <!-- ============================= Feature strip ============================= -->
      <section class="features" id="features">
        <div class="feature">
          <span class="feature-icon" aria-hidden="true">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M12 3l7 3v5c0 5-3.5 8.5-7 10-3.5-1.5-7-5-7-10V6l7-3Z"/><path d="M9.5 12l1.8 1.8L15 10"/></svg>
          </span>
          <div>
            <div class="feature-title">Secure Banking</div>
            <div class="feature-desc">256-bit SSL Encryption for your safety</div>
          </div>
        </div>
        <div class="feature">
          <span class="feature-icon" aria-hidden="true">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M13 2 4 14h7l-1 8 9-12h-7l1-8Z"/></svg>
          </span>
          <div>
            <div class="feature-title">Instant Transfers</div>
            <div class="feature-desc">Send money in seconds, 24/7</div>
          </div>
        </div>
        <div class="feature">
          <span class="feature-icon" aria-hidden="true">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M4 13v-1a8 8 0 0 1 16 0v1"/><rect x="3" y="13" width="4" height="7" rx="2"/><rect x="17" y="13" width="4" height="7" rx="2"/><path d="M20 19a3 3 0 0 1-3 3h-3"/></svg>
          </span>
          <div>
            <div class="feature-title">24/7 Support</div>
            <div class="feature-desc">We're here for you anytime, anywhere</div>
          </div>
        </div>
        <div class="feature">
          <span class="feature-icon" aria-hidden="true">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M12 2l2.4 4.9 5.4.8-3.9 3.8.9 5.4L12 19.3 7.2 17l.9-5.4L4.2 7.7l5.4-.8L12 2Z"/></svg>
          </span>
          <div>
            <div class="feature-title">100% Trusted</div>
            <div class="feature-desc">Your trust is our priority</div>
          </div>
        </div>
      </section>

      <!-- ============================= About + stats ============================= -->
      <section class="section about" id="about">
        <div>
          <p class="section-eyebrow">About AceBank</p>
          <h2 class="section-title">Banking built on trust, speed, and simplicity</h2>
          <p class="section-lead">AceBank brings full-service digital banking to your fingertips — open an account in minutes, move money instantly, and manage cards, loans, and deposits from one secure dashboard. No branches, no queues, no hidden fees.</p>
        </div>
        <div class="stats">
          <div class="stat"><div class="stat-num">2M+</div><div class="stat-label">Customers served</div></div>
          <div class="stat"><div class="stat-num">₹18,000Cr+</div><div class="stat-label">Processed securely</div></div>
          <div class="stat"><div class="stat-num">99.99%</div><div class="stat-label">Platform uptime</div></div>
          <div class="stat"><div class="stat-num">4.8★</div><div class="stat-label">Average app rating</div></div>
        </div>
      </section>

      <!-- ============================= Services ============================= -->
      <section class="section" id="services">
        <div class="center">
          <p class="section-eyebrow">Our Services</p>
          <h2 class="section-title">Everything you need to bank better</h2>
          <p class="section-lead">One account, a complete suite of financial products — all protected by bank-grade security.</p>
        </div>
        <div class="cards-grid">
          <div class="service-card">
            <span class="service-icon" aria-hidden="true"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"><path d="M3 10 12 4l9 6"/><path d="M5 10v9h14v-9"/><path d="M9 19v-5h6v5"/></svg></span>
            <h3>Savings &amp; Current</h3>
            <p>Zero-balance accounts with competitive interest and instant activation.</p>
          </div>
          <div class="service-card">
            <span class="service-icon" aria-hidden="true"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"><path d="M12 1v22"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg></span>
            <h3>Loans &amp; Credit</h3>
            <p>Personal, home, and instant loans with transparent rates and quick approval.</p>
          </div>
          <div class="service-card">
            <span class="service-icon" aria-hidden="true"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="5" width="20" height="14" rx="3"/><path d="M2 10h20"/><path d="M6 15h4"/></svg></span>
            <h3>Debit &amp; Credit Cards</h3>
            <p>Manage, freeze, and set limits on your cards in real time from the app.</p>
          </div>
          <div class="service-card">
            <span class="service-icon" aria-hidden="true"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"><path d="M4 7h16v10H4z"/><path d="M4 11h16"/><path d="M7 15h3"/><path d="M22 4 12 12 2 4"/></svg></span>
            <h3>Payments &amp; Bills</h3>
            <p>Pay bills, recharge, and transfer via IMPS/NEFT/RTGS — free and instant.</p>
          </div>
        </div>
      </section>
    </main>

    <!-- ============================= Footer ============================= -->
    <footer class="site-footer" id="contact">
      <div class="footer-grid">
        <div class="footer-brand">
          <a class="brand" href="${pageContext.request.contextPath}/index.jsp" aria-label="AceBank home">
            <span class="brand-mark">
              <svg viewBox="0 0 44 44" fill="none" aria-hidden="true">
                <path d="M22 3 41 38H3L22 3Z" fill="#2563eb"/><path d="M22 3 41 38H26L22 3Z" fill="#1e3a8a"/><path d="M22 16 30 31H14l8-15Z" fill="#fff"/>
              </svg>
            </span>
            <span class="brand-name">AceBank</span>
          </a>
          <p class="footer-about">Secure, simple and smart banking for a better tomorrow. Regulated and insured for your peace of mind.</p>
          <div class="socials">
            <a class="social" href="#" aria-label="Twitter"><svg viewBox="0 0 24 24" fill="currentColor" aria-hidden="true"><path d="M18 4h3l-7 8 8 11h-6l-5-6-5 6H2l8-9L2 4h6l4 5 6-5Z"/></svg></a>
            <a class="social" href="#" aria-label="LinkedIn"><svg viewBox="0 0 24 24" fill="currentColor" aria-hidden="true"><path d="M4 4a2 2 0 1 1 0 4 2 2 0 0 1 0-4ZM3 9h2v11H3V9Zm6 0h2v1.5c.6-1 1.7-1.8 3.3-1.8 2.4 0 3.7 1.6 3.7 4.3V20h-2v-6.4c0-1.5-.6-2.5-2-2.5-1.1 0-1.8.8-2 1.5V20H9V9Z"/></svg></a>
            <a class="social" href="#" aria-label="Facebook"><svg viewBox="0 0 24 24" fill="currentColor" aria-hidden="true"><path d="M13 22v-8h3l.5-3H13V9c0-.9.3-1.5 1.6-1.5H17V4.9c-.8-.1-1.7-.2-2.6-.2-2.6 0-4.4 1.6-4.4 4.5V11H7v3h3v8h3Z"/></svg></a>
          </div>
        </div>
        <div class="footer-col">
          <h4>Products</h4>
          <ul>
            <li><a href="#services">Savings Account</a></li>
            <li><a href="#services">Current Account</a></li>
            <li><a href="#services">Fixed Deposits</a></li>
            <li><a href="#services">Loans &amp; Cards</a></li>
          </ul>
        </div>
        <div class="footer-col">
          <h4>Company</h4>
          <ul>
            <li><a href="#about">About Us</a></li>
            <li><a href="#">Careers</a></li>
            <li><a href="#">Press</a></li>
            <li><a href="#">Blog</a></li>
          </ul>
        </div>
        <div class="footer-col">
          <h4>Support</h4>
          <ul>
            <li><a href="#">Help Center</a></li>
            <li><a href="#">1800-123-4567</a></li>
            <li><a href="#">support@acebank.com</a></li>
            <li><a href="#">Report Fraud</a></li>
          </ul>
        </div>
      </div>
      <div class="footer-bottom">
        <p>© 2026 AceBank Limited. All rights reserved.</p>
        <nav aria-label="Legal">
          <a href="#">Privacy</a>
          <a href="#">Terms</a>
          <a href="#">Security</a>
        </nav>
      </div>
    </footer>

  </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/acebank.js"></script>
</body>
</html>
