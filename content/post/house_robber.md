---
title: "LeetCode 198. House Robber"
date: 2018-03-31T22:04:55+08:00
tags:
    - Dynamic Programming
categories:
    - LeetCode
---

[desc](/images/leetcode/198_1.png)

这一题还是一道简单的动态规划题。搞一个dp数组，`dp[i]`表示抢劫前i个房子的最大收获。所以dp[i+1]有两种选择：

* 不抢劫第i个房子，所以可以抢第`i+1`个房子，`dp[i+1]=dp[i-1]+nums[i+1]`
* 抢劫第i个房子，所以不能抢第`i+1`个房子，`dp[i+1]=dp[i]`

综上，`dp[i+1]=max(dp[i], dp[i-1]+nums[i+1]`。

代码如下：

```
class Solution(object):
    def rob(self, nums):
        n = len(nums)
        if n==0: return 0
        dp = [0]*n
        for i in range(n):
        	# 加上边界情况
            dp[i] = max(dp[i-1] if i-1>=0 else 0, (dp[i-2] if i-2>=0 else 0)+nums[i])
        return dp[n-1]
```

这里时间复杂度与空间复杂度都是O(N)，其实空间复杂度可以降低到O(1)，因为每一次递推过程中，下一个值只取决于前两个值。优化之后如下：

```
class Solution(object):
    def rob(self, nums):
        prev, curr = 0, 0
        for num in nums:
            prev, curr = curr, max(prev+num, curr)
        return curr
```

