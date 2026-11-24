Gomes
```mermaid
flowchart LR
    A@{ shape: person, label: "Attacker" }
    B@{ shape: browser, label: "Browser" }
    C@{ shape: console, label: "Console" }
    D@{ shape: disk, label: "Disk" }
    E@{ shape: dbl-circ, label: "Stop" }
    F@{ shape: hex, label: "Diagnosis" }
    G@{ shape: stadium, label: "Root" }

    A --> B --> C --> D --> E
    C --> F --> G
```
