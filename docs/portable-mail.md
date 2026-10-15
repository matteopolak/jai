# Mail transport

The Mail facade retains canonical Mail_Server/Mail_Message record shapes and
mail_send and scramble. Private transport code lives in internal/net/mail.jai and uses the new independent
Curl binding module. No other Jai implementation is an input. Native ABI use was
checked against official [SMTP/MIME API documentation](https://curl.se/libcurl/c/smtp-mime.html)
and [mandatory TLS settings](https://curl.se/libcurl/c/CURLOPT_USE_SSL.html).
The implementation is newly written; no native C implementation is vendored.

Each send checks every Curl status/pointer result and releases its easy handle,
MIME object and lists. Initialization uses the existing synchronized once helper.
Headers and envelope recipients are separate: To/CC/BCC all receive the message,
while BCC is omitted from headers. MIME carries the selected UTF-8 text/HTML body
and binary file attachments. Auth uses caller fields; implicit netrc and proxy
configuration are disabled. Native C strings reject NUL and headers reject CR/LF.

Run the source-built integration test after copying the new Curl binding and
internal/bindings sources into target/portable-integration-stdlib:

```sh
python3 -B tools/check_portable_mail.py --native
```

The complete portable runner performs those copies (Curl defaults beside its
supplied POSIX module) and runs this test automatically. The receiver binds only
127.0.0.1 on an OS-selected port; all addresses use example.invalid and all auth
values are synthetic fixture strings. Ten interpreter/native scenarios check
text/HTML types, UTF-8 body bytes, binary attachments, multiple recipients,
reply/from headers, BCC omission, explicit auth, late recipient rejection and
mandatory TLS failure without a delivered message. Header injection is rejected
before connection. Linux/Windows x64 declarations are also type-checked.

Positive encrypted delivery/custom CA verification remains untested. The current
enable_ssl policy is mandatory STARTTLS; implicit SMTPS/exact reference policy,
encoded-word headers, serialization and attachment/lifetime details
require additional reviewed contracts. Transport acceptance
by the fixture is not a claim about subsequent delivery by real mail servers.

The reviewed scramble transform is implemented separately in
internal/net/mail-scramble.jai. It maps the listed alphabet (space, exclamation,
digits, uppercase, lowercase) to indices, XORs each text index with a cyclic
secret index, and returns temporary bytes. Input strings remain borrowed and
unchanged. Unsupported bytes or a nonempty text with an empty secret assert;
when optional assertions are disabled, invalid inputs return empty without
out-of-bounds access. Allocation and validation do not depend on assertion side
effects. This is reversible obfuscation, never cryptographic protection.

`python3 -B tools/check_portable_mail_scramble.py` tests all 64 single-character
secrets against the entire alphabet, bijectivity, round trips, cyclic indexing,
empty inputs and nine invalid-input executions across interpreter/native O0/O2.
Full scoped strict lint passes. The missing export was observed first in
target/mail-scramble-red.log; target/mail-scramble-final.log records passing
behavior. The ten real SMTP tests were rerun unchanged after adding the transform
(target/mail-after-scramble.log). No inherited test oracle was changed.

The numeric ordering follows the ascending character sequence listed by the
reviewed contract. That page does not independently supply a full numeric mapping
or ciphertext vector, so exact cross-implementation ciphertext remains a review
question in [Mail questions](portable-mail-questions.md). No arbitrary vector is
claimed as reference evidence.
