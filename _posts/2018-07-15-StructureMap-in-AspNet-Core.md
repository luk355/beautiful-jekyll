---
layout: post
title: StructureMap and Nested Containers in Asp.Net Core
tags: [StructureMap, Asp.Net Core, nested containers]
---

Yes, StructureMap uses [Nested Containers][sm-docs-nested] under the hood when plugged into Asp.Net Core framework as a DI container of your choice.

To prove that, have a look into the source code of [DependencyInjection NuGet package][sm-aspnetcore] which serves as an integration package. [Here][sm-interation-code] you view the code from the snippet below.

```csharp
internal sealed class StructureMapServiceScopeFactory : IServiceScopeFactory
{
    public IServiceScope CreateScope()
    {
        return new StructureMapServiceScope(Container.GetNestedContainer());
    }

    // ... details omitted
}
```

## Why is this important?

Using Nested container per request over `HttpContext` based lifecycles is based on the [StructureMap docs][sm-docs-nested] a **better, lighterweight way to scope services to an HTTP request** without coupling your code to what will soon be legacy ASP.Net runtime code.

There are a few  things to be aware of, however.

### Lifecycle rule changes

With a use of Nested Containers, lifecycle rules changes:

* `Transient` - **a new object is created for each Http request** (Nested container). This differs to the behavior of Transient lifecycle rule in the root cotainer where a new object is created for each container request (i.e. `Container.GetInstance()`)
* Instances scoped to anything but `Transient` or `AlwaysUnique` - are resolved as normal, but through the parent container. These currently are `ContainerScoped`, `ThreadLocal` and `Singleton`. 

More description can be viewed at [StructureMap docs lifecycle page][sm-docs-lifecycles].

### Disposing services

Disposing a nested container will also dispose all objects created with the default Transient lifecycle by the nested container that implement the `IDisposable` interface. 

When working outside of a nested container and especially when using `Transient` lifecycle, make sure to read [StructureMap disposing page][sm-docs-disposing]. What object gets disposed changes with version 4 of StructureMap.

## Resources

* [StructureMap nested containers documentation page][sm-docs-nested]
* [StructureMap lifecycles documentation page][sm-docs-lifecycles]
* [StructureMap and IDisposable documentation page][sm-docs-disposing]
* [Github project of StructureMap integration package into Asp.Net Core][sm-aspnetcore]
* [Getting started with StructureMap in Asp.Net Core][andrew-configuring-sm]

[andrew-configuring-sm]: https://andrewlock.net/getting-started-with-structuremap-in-asp-net-core/
[sm-docs-nested]: http://structuremap.github.io/the-container/nested-containers/
[sm-docs-lifecycles]: http://structuremap.github.io/object-lifecycle/supported-lifecycles/
[sm-docs-disposing]: http://structuremap.github.io/the-container/disposing/
[sm-aspnetcore]: https://github.com/structuremap/StructureMap.Microsoft.DependencyInjection
[q-stackoverflow]: https://stackoverflow.com/questions/47640296/structuremap-net-core-windows-service-nested-containers
[q-servicestack]: https://forums.servicestack.net/t/structuremap-ioc-nested-container-per-request/3659
[sm-interation-code]: https://github.com/structuremap/StructureMap.Microsoft.DependencyInjection/blob/0d20c416c5423f5153a71589f5082a9b234b123c/src/StructureMap.Microsoft.DependencyInjection/StructureMapServiceScopeFactory.cs