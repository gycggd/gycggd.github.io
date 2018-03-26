---
title: "LeetCode 136. Single Number"
date: 2018-03-19T11:51:49+08:00
tags:
    - Bit Manipulation
    - Single Number
categories:
    - Leetcode
---

# Single Number I

![Desc](/images/leetcode/136_1.png)

题目链接：[136. Single Number](https://leetcode.com/problems/single-number/description/)

一个数组所有数字都包含两次，除了一个数字包含一次，要找出这个数字非常容易。

最简单的方法是使用一个counterMap来记录每个数字出现的次数然后返回次数为1的数字。

但在这个问题里我们还有更好的解法。

## Solution 1

```
def singleNumber(self, nums):
    return 2*sum(set(nums))-sum(nums)
```

但这里还是占用了O(1)的空间。

## Solution 2

$A xor A=0, A xor B=B xor A, A xor B xor C=A xor (B xor C)$

使用异或运算，因为异或运算具有交换律和结合律，所以将所有的值进行异或运算，出现两次的值异或结果为0，0异或出现一次的值就是出现一次的值，也就是我们要的结果。

```
def singleNumber(self, nums):
	from functools import reduce
    return reduce(lambda a, b: a^b, nums)
```

要不占用额外空间，可以用nums[0]来存储：

```
def singleNumber(self, nums):
    from functools import reduce
    return nums[0]^(reduce(lambda a, b: a^b, nums[1:]) if len(nums)>1 else 0)
```

# Single Number II

![Desc](/images/leetcode/137_1.png)

题目链接：[137. Single Number II](https://leetcode.com/problems/single-number-ii/description/)

## Solution 1

```
def singleNumber(self, nums):
    return (int)((3*sum(set(nums)) - sum(nums)) / 2)
```

## Solution 2

```
def singleNumber(self, nums):
    n1, n2 = 0, 0
    
    for num in nums:
        n2 ^= (n1&num)
        n1 ^= num
        mask = ~(n1&n2)
        n1 &= mask
        n2 &= mask
    return n1
```

这段代码一眼看过去比较难懂，但理解之后思路其实非常清晰，并且可以用这种方法来解决所有类似的问题。

以[5, 4, 5 ,6, 4, 5, 4]为例，

![example](/images/leetcode/137_2.png)

感受一下上面n1，n2值的变化过程，可以发现 (n2的i位)(n1的i位) 拼接起来一直是目前遇到的所有数字在i位为1的次数对3取余，所以n1为1说明该位上有1个1，n2为1说明该位有2个1，n1、n2都为1说明该位有3个1。

![bits counter](/images/leetcode/137_3.png)

那么来从每一bit的角度看下代码是如何做到这一点的。

* `n2 ^= (n1&num)`
	* 如果n1的第i个bit为1且num的第i个bit也为1，且n2的第i个bit为0，那么如果n2的第i个bit就为1，即进位，如果n2的第i个bit为1，n2的第i个bit也要进位，所以为0
	* 如果n1的第i个bit不为1或num的第i个bit不为1，n2的第i个bit原来是什么就还是什么
* `n1 ^= num`: 
	* 如果n1的第i个bit为1且num的第i个bit也为1，进位，n2第i个bit加一，n1的第i个bit设为0。
	* 如果n1的第i个bit为0且num的第i个bit也为0，不变，因为i位上1的数目没有变化。
	* 如果n1的第i个bit与num的第i个bit不同，那么肯定有一个为1另一个为0，这样n1设为1。
* `mask = ~(n1&n2); n1&=mask; n2&=mask`:
	* 对于n1&n2为1的位数，我们知道已经有三个1了，除了一个数出现一次，其他数都出现3次，我们要把到3次的给消除掉，所以用来做&运算的`mask=~(n1&n2)`。

# 通用解法

按照类似的思路，我们可以解决所有“一个数组中除了一个数字出现了m次，其他的数字都出现了k次，找出这个出现m次的数字”这种问题。

首先确定需要几个数字来对每一位做计数器，需要log(max(m, k))上取整个数字。因为比如m=3, k=5,那么我们需要n3=1来表示出现4次，n2=1来表示出现2次，n1=1来表示出现1次。

令p=log(max(m, k))的上取整。

对于计数器每一位来说，如果所有低位都为1且num为1，则考虑进位后的情况，否则不变，可以用异或运算来做到。
mask的构成是根据k来构造的。如果k=5 (101)，则mask=~(x3&~x2&x1),如果k=10 (1010)，则mask=~(x4&~x3&x2&~x1)。

那么代码如下:

```
for num in nums:
	n_p ^= (n_(p-1) & n_(p-2) &...& n_1 & num)
	n_(p-1) ^= (n_(p-2) & n_(p-3) &...& n_1 & num)
	...
	n_1 ^= num

	# kj 表示 y 的第j位
	mask = ~(y1 & y2 & ... & ym) where yj = nj if kj = 1, and yj = ~nj if kj = 0.

	n1 &= mask
	...
	n_p &= mask

return n_j where mj=1 (j可以取任意使mj=1的值)
```

来看一个例子吧，m=3,k=5

那么p=3, 代码如下:
```
n1, n2, n3 = 0, 0, 0
for num in nums:
	n3 ^= (n2&n1&num)
	n2 ^= (n1&num)
	n1 ^= num
	mask = ~(n1&~n2&n3)
	n1, n2, n3 = n1&mask, n2&mask, n3&mask
return n1  # return n2 也行
```

# 260. Single Number III

![260](/images/leetcode/260_1.png)

前面的问题都是一个数组其他数出现次数都一样，只有一个数不一样，这一题是两个数出现一次，其他数都出现两次，之前的解法也就失效了。

还是考虑异或运算，如果将所有数进行异或运算，那么结果为只出现一次的两个数异或的值，有什么办法可以将两个数提取出来吗？

异或运算的基本含义是如果a!=b,则a^b=1,如果a==b,则a^b=0。

那么假设我们两个出现一次的数为m和n，我们就可以知道m和n哪些位不同了。

假设m和n第k位不同，那我们可以取x=0,y=0，然后对nums数组中每一个数num进行判断，
* 如果num&(1<<k)==0, x^=num
* 如果num&(1<<k)==1, y^=num

这样m，n的值即为x，y了。

因为我们通过第k位把nums划分为两个数组，每一个数组就变成了其他数出现两次，一个数出现一次，只需要对每个数组分别进行异或就可以得到两个出现一次的数了。

代码如下：

```
m_xor_n = 0
for num in nums:
	m_xor_n ^= num

k = 0
while not (m_xor_n&(1<<k)):
	k += 1

m, n = 0, 0
for num in nums:
	if num&(1<<k):
		m ^= num
	else:
		n ^= num

return m, n
```

End