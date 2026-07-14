#!/usr/bin/env python3
"""Assemble static HTML previews from the JSP sources (no servlet container).
Resolves ${contextPath}, page title, active-nav EL, strips scriptlets/directives,
and inlines the app-header/app-footer includes. For local visual QA only."""
import re, shutil, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
WEBAPP = ROOT / "src/main/webapp"
OUT = ROOT / "target/preview"
HEADER = WEBAPP / "WEB-INF/includes/app-header.jsp"
ADMIN_HEADER = WEBAPP / "WEB-INF/includes/admin-header.jsp"
FOOTER = WEBAPP / "WEB-INF/includes/app-footer.jsp"

def strip_common(t):
    t = t.replace("<%= ctx %>", "").replace("<%= request.getContextPath() %>", "")
    t = t.replace("${pageContext.request.contextPath}", "")
    t = re.sub(r"<%@.*?%>", "", t, flags=re.DOTALL)          # directives
    t = re.sub(r"<jsp:include[^>]*?/>", "", t)                # includes
    t = re.sub(r"<%.*?%>", "", t, flags=re.DOTALL)            # scriptlets
    return t

def apply_shell_el(t, active, title):
    t = t.replace("${pageTitle}", title)
    t = re.sub(r"\$\{activeNav=='([a-z]+)' \? 'active' : ''\}",
               lambda m: "active" if m.group(1) == active else "", t)
    return t

def build_shell_page(src: Path):
    body = src.read_text(encoding="utf-8")
    active = (re.search(r'setAttribute\("activeNav",\s*"([^"]+)"\)', body) or [None, ""])[1]
    title = (re.search(r'setAttribute\("pageTitle",\s*"([^"]+)"\)', body) or [None, "AceBank"])[1]
    hdr = ADMIN_HEADER if "admin" in src.parts else HEADER
    header = apply_shell_el(strip_common(hdr.read_text(encoding="utf-8")), active, title)
    footer = strip_common(FOOTER.read_text(encoding="utf-8"))
    inner = strip_common(body)
    return header + inner + footer

def build_standalone(src: Path):
    return strip_common(src.read_text(encoding="utf-8"))

# page name -> (source path, is_shell)
PAGES = {
    "index":     (WEBAPP / "index.jsp", False),
    "login":     (WEBAPP / "login.jsp", False),
    "dashboard": (WEBAPP / "WEB-INF/views/dashboard.jsp", True),
    "accounts":  (WEBAPP / "WEB-INF/views/accounts.jsp", True),
    "transfer":  (WEBAPP / "WEB-INF/views/transfer.jsp", True),
    "bills":     (WEBAPP / "WEB-INF/views/bills.jsp", True),
    "cards":     (WEBAPP / "WEB-INF/views/cards.jsp", True),
    "transactions": (WEBAPP / "WEB-INF/views/transactions.jsp", True),
    "loans":     (WEBAPP / "WEB-INF/views/loans.jsp", True),
    "services":  (WEBAPP / "WEB-INF/views/services.jsp", True),
    "profile":   (WEBAPP / "WEB-INF/views/profile.jsp", True),
    "settings":  (WEBAPP / "WEB-INF/views/settings.jsp", True),
    "help":      (WEBAPP / "WEB-INF/views/help.jsp", True),
    "admin-dashboard": (WEBAPP / "WEB-INF/views/admin/dashboard.jsp", True),
}

def main():
    OUT.mkdir(parents=True, exist_ok=True)
    if (OUT / "assets").exists():
        shutil.rmtree(OUT / "assets")
    shutil.copytree(WEBAPP / "assets", OUT / "assets")
    wanted = sys.argv[1:] or list(PAGES)
    for name in wanted:
        src, is_shell = PAGES[name]
        if not src.exists():
            continue
        html = build_shell_page(src) if is_shell else build_standalone(src)
        (OUT / f"{name}.html").write_text(html, encoding="utf-8")
        print("built", name)

if __name__ == "__main__":
    main()
