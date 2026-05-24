To format (automatically) a Cangjie `.cj` file in vscode, one can:

1. Install the [Cangjie extension](https://marketplace-visualstudio-com.translate.goog/items?itemName=IDE-Innovation-Lab.cangjie&_x_tr_sl=de&_x_tr_tl=en&_x_tr_hl=en-US&_x_tr_pto=wapp)

2. Install the [Custom Local Formatters extension](https://marketplace.visualstudio.com/items?itemName=jkillian.custom-local-formatters)

3. Setup a tiny script to invoke as the formatter:
```bash
#!/bin/bash

TMP_FILE=/tmp/cangjieinput.cj
# This is needed because cjfmt works on files, vscode passes stdin, expects stdout
tee $TMP_FILE > /dev/null
cjfmt -f $TMP_FILE > /dev/null
cat $TMP_FILE
```
4. Configure the formatter in `settings.json`
```json
{
    "files.associations": {
        "*.cj": "Cangjie"
    },
    "customLocalFormatters.formatters": [
        {
            "command": "cjfmt_vscode.sh",
            "languages": [
                "Cangjie"
            ]
        }
    ]
}
```
