import subprocess

services = subprocess.check_output(
    ["sc", "query", "state=", "all"],
    text=True,
    errors="ignore"
)

service_names = []

for line in services.splitlines():
    if "SERVICE_NAME:" in line:
        service_names.append(line.split(":", 1)[1].strip())

vuln = []

for svc in service_names:
    try:
        output = subprocess.check_output(
            ["sc", "qc", svc],
            text=True,
            errors="ignore"
        )

        for line in output.splitlines():
            if "BINARY_PATH_NAME" in line:
                path = line.split(":", 1)[1].strip()

                lower = path.lower()
                exe = lower.find(".exe")
                if exe != -1:
                    executable = path[:exe + 4]
                else:
                    executable = path

                if not executable.startswith('"') and " " in executable:
                    vuln.append((svc, path))
                break

    except Exception:
        pass

if vuln:
    print("Potential unquoted service paths:\n")
    for svc, path in vuln:
        print(f"{svc}\n  {path}\n")
else:
    print("No unquoted service paths found.")