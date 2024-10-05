```markdown
# Web Vulnerability Scanner

## Description
This tool is a simple web vulnerability scanner written in Ruby. It scans a given URL for possible SQL Injection and Cross-Site Scripting (XSS) vulnerabilities by sending payloads and analyzing the responses.

## Features
- **SQL Injection Scan:** Sends a series of SQL payloads to the target URL and checks for database errors in the response.
- **XSS Scan:** Sends XSS payloads and checks if the script is executed, which could indicate a vulnerability.
- **Logging:** Logs all events, including potential vulnerabilities and errors, in a `scanner.log` file for easy review.
  
## Usage
You can run the script from the command line with options to specify the URL and the type of scan you'd like to perform.

### Command Line Options
- `-u`, `--url` : The target URL to scan.
- `-t`, `--type` : The type of scan to perform. Options are:
  - `sql` : Scan only for SQL Injection vulnerabilities.
  - `xss` : Scan only for XSS vulnerabilities.
  - `both` : (Default) Scan for both SQL Injection and XSS vulnerabilities.

### Example Usage
1. **Scan for SQL Injection only:**
   ```bash
   ruby scanner.rb -u http://example.com -t sql
   ```

2. **Scan for XSS only:**
   ```bash
   ruby scanner.rb -u http://example.com -t xss
   ```

3. **Scan for both SQL Injection and XSS (default):**
   ```bash
   ruby scanner.rb -u http://example.com
   ```

## Logging
All scanning activity, including vulnerabilities found or errors encountered, is logged in the `scanner.log` file. Make sure to check this file for more details after running the tool.

## Dependencies
The tool requires the following Ruby gems:
- `httparty`: To send HTTP requests.
- `optparse`: To parse command-line options.
- `uri`: To handle URL encoding and parsing.

You can install the required gems by running:
```bash
gem install httparty
```

## Notes
- Make sure to use the tool responsibly. Scanning websites without permission may violate legal and ethical guidelines.
- The tool includes a 1-second delay between requests to avoid overwhelming the target server and to reduce the risk of being blocked.

## License
This project is licensed under the MIT License.
