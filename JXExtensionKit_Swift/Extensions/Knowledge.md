
在oc中为了增强已有类的功能，我们经常使用分类。使用分类，我们可以在不破坏原有类的结构的前提下，对原有类进行模块化的扩展。但是在swift中没有分类这种写法了。相对应的是swift中只有扩展(Extensions)。扩展就是向一个已有的类、结构体、枚举类型或者协议类型添加新功能（functionality）。扩展和 Objective-C 中的分类类似。（不过与 Objective-C 不同的是，Swift 的扩展没有名字。）

注：注意扩展中不能有存储类型的属性，只可以添加计算型实例属性和计算型类型属性，或者也可以利用runtime给继承与OC中的类添加属性

黑魔法Method Swizzling在swift中实现的两个困难点

1.swizzling 应该保证只会执行一次.
2.swizzling 应该在加载所有类的时候调用.

UnsafeBufferPointer、 UnsafeMutableBufferPointer，能让你查看或更改一个连续的内存块。

UnsafeRawBufferPointer、UnsafeMutableRawBufferPointer能让你查看或更改一个连续内存块的集合，集合里面每个值对应一个字节的内存。

