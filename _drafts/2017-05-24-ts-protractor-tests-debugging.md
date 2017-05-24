---
layout: post
title: Debugging Protractor TypeScript tests with VS Code issues
tags: [TypeScript, Protractor, VS Code]
---

http://www.bilyachat.com/2017/01/debug-protractor-typescript-tests-with.html

VS Code configuration

```json
{
    "version": "0.2.1",
    "configurations": [
        {
            "name": "Debug Protractor",
            "type": "node",
            "request": "launch",
            "stopOnEntry": false,
            "program": "${workspaceRoot}/node_modules/protractor/bin/protractor",
            "args": [
                "${workspaceRoot}/protractor.config.debug.js"
            ],
            "preLaunchTask": "builde2e",
            "sourceMaps": true,
            "outFiles": [ "${workspaceRoot}/dist/e2e/**/*.js" ]
        }
    ]
}
```