---
layout: post
title: Enums in TypeScript Declaration files
tags: [TypeScript, Declaration Files, Definition Files, Typings]
---

**TLDR:** Do not define your enums in your TypeScript Declaration (`*.d.ts`) files, ever.

As a developer coming from a `C# world` I was dealing today with a rather strange error when implementing new functionality for one of our products.

I had to implement couple of services, and while doing so, I managed to define one of my enums in a Declaration file (previously called as _Definition files_ or _Typings files_). I didn't care about where it sits at that time as I would move all the pieces to correct locations afterwards. The file content were looking similar to the ones below:

```typescript
// file: foo.service.d.ts

export enum FooEnum {
    EnumValue = 1
}

export interface IFooService {
    doFoo(foo: FooEnum):void;
}
```

```typescript
// file: foo.service.ts

import {FooEnum, IFooService} from './foo.service.d'

export class FooService implements IFooService {
    doFoo(foo:FooEnum):void {
    }
}
```

Suprisingly enough, the app didn't work and I was getting an `Cannot read property 'EnumValue' of undefined` error (or `Error: Cannot find module './foo.service.d'` when running app in NodeJs).

```typescript
// file: app.ts

import {FooEnum} from './foo.service.d'
import {FooService} from './foo.service'

let service = new FooService();
service.doFoo(FooEnum.EnumValue);
```

The error dissapeared when I moved the enum definition into proper TypeScript file. The tricky part was that TypeScript compiled app just fine and error occured only after running the app.

The example application [can be found on my GitHub](https://github.com/luk355/blog-example-enums-in-ts-declaration-files).

### Update

There has been a discussion on [stackoverflow][stackoverflow-amd] recently about the same matter for [AMD][amd] specification. 

The best suggestion is to export enum as a variable being a number/string from the TypeScript Declaration file. This ensures TypeScript validation when assigning the enum property value outside of the enum. The code below is taken from the [stackoverflow thread][stackoverflow-amd].

```typescript
///messagelevel.d.ts
export type MessageLevel = "Unknown" | "Fatal" | "Critical" | "Error";

///main.d.ts
import * as ml from "./MessageLevel";

interface IMyMessage {
    name: string;
    level: ml.MessageLevel;
    message: string;
}
```

Other potential solution could be to implement only enum interface in Typings Declaration file and then implement the actual enum in Typescript file (also discribed on [stackoverflow thread][stackoverflow-amd]).

## What are TypeScript Declaration files

Just a quick summary what TypeScript Declaration files are:

* Provides type definitions for any JavaScript (JS) file - enhancing JS development with AutoCompletion, type checking etc.
* Are not transpiled into JS files when running TypeScript compiler as therefore cannot contain any functionality
* Can be written additionally to any of the JS code
* Exists for most of the JS frameworks available
* Are currently available through npm under `@Types` organisation and can be installed by running `npm install @Types/<package-name> --save-dev`

## Resources

* [Working example on GitHub](https://github.com/luk355/blog-example-enums-in-ts-declaration-files)
* [Enums on Typescriptlang.org](https://www.typescriptlang.org/docs/handbook/enums.html)
* [Official TypeScript Declaration Files introduction](https://www.typescriptlang.org/docs/handbook/declaration-files/introduction.html)
* [How to refer to Typescript enum in d.ts file when using AMD on Stackoverflow][stackoverflow-amd]



[amd]: https://en.wikipedia.org/wiki/Asynchronous_module_definition
[stackoverflow-amd]: https://stackoverflow.com/questions/38335668/how-to-refer-to-typescript-enum-in-d-ts-file-when-using-amd/48159049#48159049  "How to refer to Typescript enum in d.ts file when using AMD on Stackoverflow"