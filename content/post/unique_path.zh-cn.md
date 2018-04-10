---
title: "LeetCode 62. Unique Paths"
date: 2018-04-10T01:38:55+08:00
tags:
    - Dynamic Programming
categories:
    - LeetCode
---

![desc](/images/leetcode/62_1.png)

# 动态规划

初始状态:

`dp[i][0] = 1`
`dp[0][i] = 1`

递推公式：

`dp[i][j]=dp[i-1][j]+dp[i][j-1]`

返回：

`dp[-1][-1]`

代码：

```
class Solution:
    def uniquePaths(self, m, n):
        dp = [[0]*n for _ in range(m)]
        for i in range(m): dp[i][0] = 1
        for j in range(n): dp[0][j] = 1
        
        for i in range(1, m):
            for j in range(1, n):
                dp[i][j] = dp[i][j-1]+dp[i-1][j]
        return dp[-1][-1]
```

```
class Solution:
    def uniquePaths(self, m, n):
        dp = [1]*n
        for i in range(m-1):
            for j in range(n):
                dp[j] += (dp[j-1] if j-1>=0 else 0)
        return dp[-1]
```

# 组合

问题即为m+n-2次移动，在其中取m-1次向下移动，不需要考虑顺序。

```
class Solution:
    def uniquePaths(self, m, n):
        def f(n):
            ret = 1
            for i in range(1, n+1):
                ret *= i
            return ret
        return f(m+n-2)//(f(m-1)*f(n-1))
```