---
title: "LeetCode 486. Predict the Winner"
date: 2018-04-02T18:43:03+08:00
tags:
    - Dynamic Programming
categories:
    - LeetCode
---

![desc](/images/leetcode/486_1.png)

# 非递归方式

这一题可以通过定义一个矩阵dp，`dp[i][j]`表示当原来的nums数组只剩下`nums[i:j]`时，选手可以获得的最多的分数。

那么初始情况是：

`dp[i][i]=nums[i]`

递推公式为：

`dp[i][j]=max(sum(nums[i:j])-dp[i][j-1], sum(nums[i:j])-dp[i+1][j])`

`dp[i][j-1]`和`dp[i+1][j]`分别是选择头和尾时，对手可以获得的分数，用sum(nums[i:j])减去对手的分数即为自己的分数。

返回结果为：

分数为`dp[0][len(nums)-1]`，对比`dp[0][len(nums)-1]*2`和`sum(nums)`的大小即可~

代码如下：

```
class Solution:
    def PredictTheWinner(self, nums):
        N = len(nums)
        dp = [[0]*N for _ in range(N)]
        pre_sum = [nums[0]]*(N+1)
        # 用prefix sum来降低求sum(nums[i:j])的复杂度
        pre_sum[-1] = 0
        for i in range(1, N):
            pre_sum[i] = pre_sum[i-1]+nums[i]
        for i in range(N):
            dp[i][i] = nums[i]
        for l in range(1, N):
            for i in range(N-l):
            	# 递推
                dp[i][i+l] = max(pre_sum[i+l]-pre_sum[i-1]-dp[i+1][i+l], pre_sum[i+l]-pre_sum[i-1]-dp[i][i+l-1])
        return dp[0][N-1]*2>=pre_sum[N-1]
```

# 递归方式

Recursion with memory.

```
class Solution:
    def PredictTheWinner(self, nums):
        total = sum(nums)
        memo = {}
        def score(l, r, t):
            if l>r: return 0
            if (l, r) not in memo:
                memo[(l, r)] = t-min(score(l+1, r, t-nums[l]), score(l, r-1, t-nums[r]))
            return memo[(l, r)]
        sc = score(0, len(nums)-1, total)
        return sc>=total-sc
```