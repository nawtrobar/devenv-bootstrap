---
name: secure-web-development
description: Use when working on any web application — writing endpoints, handling user input, implementing auth, managing sessions, processing file uploads, or doing redirects. Ensures secure coding practices are applied from the start rather than patched in later. Also use when a user requests a security scan or audit of web application code.
---

# Secure Web Development

Approach code from a bug hunter's perspective. Make applications as secure as possible without breaking functionality.

**Key Principles:**
- Defense in depth: never rely on a single security control
- Fail securely: when something fails, fail closed (deny access)
- Least privilege: grant minimum permissions necessary
- Validate everything server-side: never trust user input
- Encode output for context: HTML, JS, URL, and CSS contexts each need different encoding

---

## Access Control

For **every** data point and action requiring authentication:

- Each user must only access/modify their own data — verify ownership at the data layer, not just the route level
- Use UUIDs instead of sequential IDs (non-guessable)
- Check authorization on every request, not just at routing
- Return 404 (not 403) when a user requests another user's resource — prevents enumeration

```python
# SAFE pattern
def get_resource(resource_id, current_user):
    resource = db.find(resource_id)
    if resource is None or resource.owner_id != current_user.id:
        return 404  # Don't reveal if resource exists
    return resource
```

**Common pitfalls:** IDOR, privilege escalation, mass assignment (filter which fields users can update)

---

## XSS Prevention

Every input controllable by the user must be sanitized. Don't forget indirect inputs:
- URL parameters and fragments
- HTTP headers used in the app (Referer, User-Agent if displayed)
- Data from third-party APIs displayed to users
- WebSocket messages, postMessage from iframes
- Error messages that reflect user input
- SVG file uploads (can contain JavaScript)

**Protection:**
- Use framework's built-in escaping (React JSX, Vue `{{ }}`)
- Content Security Policy: `default-src 'self'; script-src 'self'` — avoid `'unsafe-inline'`
- `X-Content-Type-Options: nosniff`
- DOMPurify for HTML sanitization

---

## CSRF Protection

Every state-changing endpoint needs CSRF protection — including login, signup, password reset, and OAuth callbacks.

- Generate cryptographically random tokens tied to the user session
- Validate on every state-changing request — missing token = rejected
- `SameSite=Strict` cookies combined with CSRF tokens (defense in depth)
- Never put CSRF tokens in URLs

---

## SQL Injection

```python
# UNSAFE
cursor.execute(f"SELECT * FROM users WHERE id = {user_id}")

# SAFE
cursor.execute("SELECT * FROM users WHERE id = %s", (user_id,))
```

Watch for: ORDER BY clauses (can't parameterize — whitelist allowed columns), LIKE wildcards (`%`, `_`), dynamic table/column names.

---

## Open Redirect

Only accept relative paths (`/dashboard`) not full URLs, or use an allowlist of approved domains. Block bypass techniques:
- `@` symbol: `https://legit.com@evil.com`
- Protocol-relative: `//evil.com`
- Double encoding: `%252f%252fevil.com`
- Unicode homographs: `https://legіt.com` (Cyrillic і)

---

## SSRF Prevention

Any feature where the server fetches a URL provided by the user (webhooks, URL previews, PDF generators, import-from-URL):

- Allowlist approach: only allow pre-approved domains
- Resolve DNS and validate the resolved IP is not private/internal
- Block cloud metadata endpoints: `169.254.169.254` (AWS/GCP/Azure/DO)
- Set request timeouts and response size limits
- DNS rebinding: resolve twice, ensure both resolve to same external IP

---

## File Upload Security

- Validate file extension AND magic bytes (not just Content-Type header)
- Rename to random UUID — discard original filename
- Store outside webroot or on a separate domain
- Set `Content-Disposition: attachment` to force download
- SVG uploads: sanitize or disallow (can contain JavaScript)
- ZIP archives: validate extracted paths against base directory (ZIP slip)

---

## Password & Session Security

```python
# SAFE password hashing
from argon2 import PasswordHasher
PasswordHasher().hash(password)  # Argon2id, bcrypt, or scrypt — never MD5/SHA1
```

- Minimum 8 chars (12+ recommended), no maximum length
- Check against breached password lists
- Rate limit authentication endpoints
- Invalidate sessions on logout and on privilege changes
- Session tokens: 128+ bits entropy

---

## JWT Security

- Always specify algorithm on verification — never trust the token header
- Reject `alg: none`
- Use 256+ bit random secrets (not passwords or phrases)
- Always set `exp` claim
- Store in `httpOnly; Secure; SameSite=Strict` cookies — never `localStorage`

---

## Secrets and Sensitive Data

Never expose in client-side code or responses:
- API keys, database credentials, JWT signing secrets
- Full credit card numbers, SSNs, passwords (even hashed)
- Internal IP addresses, stack traces, server software versions

Check: JavaScript bundles, HTML comments, hidden form fields, SSR hydration data, `REACT_APP_*` / `NEXT_PUBLIC_*` env vars

---

## Security Headers (all responses)

```
Strict-Transport-Security: max-age=31536000; includeSubDomains; preload
Content-Security-Policy: default-src 'self'; script-src 'self'; frame-ancestors 'none'
X-Content-Type-Options: nosniff
X-Frame-Options: DENY
Referrer-Policy: strict-origin-when-cross-origin
Cache-Control: no-store  (sensitive pages only)
```

---

## XXE Prevention

Any XML parsing (SOAP, XML file uploads, DOCX/XLSX, SVG, SAML):

```python
# Python — disable external entities
from lxml import etree
parser = etree.XMLParser(resolve_entities=False, no_network=True)
# Or: import defusedxml
```

---

## Path Traversal

```python
# SAFE — canonicalize and verify against base
import os
def safe_join(base_dir, user_path):
    base = os.path.abspath(base_dir)
    target = os.path.abspath(os.path.join(base, user_path))
    if not target.startswith(base):
        raise ValueError("Path traversal detected")
    return target
```

---

## GraphQL

- Disable introspection in production
- Implement query depth limiting (max ~10 levels)
- Enforce query cost/complexity limits
- Limit operations per request (batch attack prevention)
