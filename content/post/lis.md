---
title: "LeetCode 300. Longest Increasing Subsequence"
date: 2018-03-23T22:09:18+08:00
tags:
	- Dynamic Programming
	- Binary Search
categories:
	- Leetcode
---

[674. Longest Continuous Increasing Subsequence](https://leetcode.com/problems/longest-continuous-increasing-subsequence/description/) 与 [LeetCode 300. Longest Increasing Subsequence](https://leetcode.com/problems/longest-increasing-subsequence/description/) 是两道递增子串的问题。

# 674. Longest Continuous Increasing Subsequence

![674](/images/leetcode/674_1.png)

这一题是一题简单题，只需要在每一个位置判断是否破坏了递增，破坏了则从长度为1开始重来，没破坏则继续。

```
class Solution:
    def findLengthOfLCIS(self, nums):
        if not nums: return 0
        l, ret, minimum = 1, 1, nums[0]
        for i, n in enumerate(nums[1:]):
            if n>minimum:
                l, ret, minimum = l+1, max(ret, l+1), n
            else:
                l, minimum = 1, n
        return ret
```

# LeetCode 300. Longest Increasing Subsequence

![300](/images/leetcode/300_1.png)

这一题是要找出最长的递增子串，没有要求连续，难度有所增加，可以用动态规划来解决，维护一个dp数组，dp[i]表示长度为i的递增子串最后一个元素的最小取值，那么之后的元素只要大于这个最小取值我们就可以得到更长的递增子串了。

```
class Solution:
    def lengthOfLIS(self, nums):
    	# 初始化最小取值为sys.maxsize, 最长子串长度为0
        dp, l = [sys.maxsize] * len(nums), 0
        for n in nums:
        	# 找到n可以更新长度为多少的递增子串的最后元素的最小取值
            idx = bisect.bisect_left(dp, n)
            # 如果n大于所有元素，最长递增子串长度加1
            if idx==l:
                l += 1
            # 更新
            dp[idx] = n
        return l
```
