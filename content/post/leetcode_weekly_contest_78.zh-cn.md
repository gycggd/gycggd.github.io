---
title: "Leetcode Weekly Contest 78"
date: 2018-04-01T12:15:33+08:00
tags:
    - Dynamic Programming
categories:
    - LeetCode
---

# 808. Soup Servings

![desc](/images/leetcode/808_1.png)

这一题最重要的一点就是Notes里的一行提示：`Answers within 10^-6 of the true value will be accepted as correct.`。所以说审题很重要啊= =。

因为这行提示，当N很大的时候，这个概率是离1非常近的，所以可以直接返回1。剩余部分用动态规划来解决，这里最小粒度是25，用`N=(N+24)//25`来简化问题。估计一个阈值500来处理当N很大的情况（直接返回1）。

```
class Solution:
    def soupServings(self, N):
        memo = {}
        def dp(n1, n2):
        	# 当其中有一个少于等于0时，可以直接返回
            if n1<=0 and n2<=0: return 0.5
            if n1<=0: return 1
            if n2<=0: return 0
            if (n1, n2) not in memo:
            	# 4种情况
                memo[(n1, n2)] = (dp(max(0, n1-4), n2)+dp(max(0, n1-3), max(0, n2-1))+dp(max(0, n1-2), max(0, n2-2))+dp(max(0, n1-1), max(0, n2-3)))*0.25
            return memo[(n1, n2)]
        N = (N+24)//25
        if N>500:
            return 1
        return dp(N, N)
```

# 809. Expressive Words

![desc](/images/leetcode/809_1.png)

这一题是普通的字符串处理题。

```
class Solution:
    def expressiveWords(self, S, words):
        def f(s1, s2):
            i1, i2 = 0, 0
            while i1<len(s1) and i2<len(s2):
                c1, c2 = s1[i1], s2[i2]
                cnt1, cnt2 = 1, 1
                if c1!=c2:
                    return False
                while i1+1<len(s1) and s1[i1+1]==c1:
                    i1, cnt1 = i1+1, cnt1+1
                while i2+1<len(s2) and s2[i2+1]==c2:
                    i2, cnt2 = i2+1, cnt2+1
                if (cnt1<3 and cnt1!=cnt2) or cnt1<cnt2:
                    return False
                i1, i2 = i1+1, i2+1
            return i1==len(s1) and i2==len(s2)
        return sum(f(S, w) for w in words)
```

# 810. Chalkboard XOR Game

![desc](/images/leetcode/810_1.png)

这一题contest进行的时候少了个条件：`Also, if any player starts their turn with the bitwise XOR of all the elements of the chalkboard equal to 0, then that player wins.`

问题可以转化为：

把nums全部取异或得到一个xor，之后每个人轮流取一个数和xor进行异或，如果开始时xor为0则获胜。

两种情况：

* xor==0，直接获胜
* xor!=0，
	* nums长度为偶数
		* 这种情况所有数不可能都相等，所以至少有两个数不同（否则xor为0）。所以Alice只要取一个和xor不同的数即可保证异或值不为0，因此Alice不会输。
		* 这种情况Alice必胜
	* nums长度为奇数
		* 必输

代码如下：

```
def xorGame(self, nums):
    xor = 0
    for i in nums: xor ^= i
    return xor == 0 or len(nums) % 2 == 0
```

# 811. Subdomain Visit Count

![desc](/images/leetcode/811_1.png)

这一题也是字符串处理加上一个map就可以解决的。

```
class Solution:
    def subdomainVisits(self, cpdomains):
        counter = collections.Counter()
        for s in cpdomains:
            items = s.split(' ')
            cnt = int(items[0])
            domains = items[1].split('.')[::-1]
            for i in range(len(domains)):
                counter['.'.join(domains[:i+1][::-1])] += cnt
        return [str(counter[k])+' '+k for k in counter]
```