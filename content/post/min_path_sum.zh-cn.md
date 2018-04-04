---
title: "LeetCode 64. Minimum Path Sum"
date: 2018-04-04T13:06:45+08:00
tags:
    - Dynamic Programming
categories:
    - LeetCode
---

![desc](/images/leetcode/64_1.png)

这一题是一道简单的动态规划题，`dp[i][j]`表示从(0, 0)到(i, j)的min path sum。

初始状态：

`dp[i][0]`和`dp[0][j]`是第一行和第一列的prefix sum

递推公式：

`dp[i][j]=min(dp[i-1][j], dp[i][j-1])+grid[i][j]`

输出：

`dp[-1][-1]`


# O(MN) Time, O(MN) Space

```
class Solution:
    def minPathSum(self, grid):
        if not grid or not grid[0]: return 0
        m, n = len(grid), len(grid[0])
        dp = [[0]*n for _ in range(m)]
        dp[0][0] = grid[0][0]
        for i in range(1, m):
            dp[i][0] = dp[i-1][0]+grid[i][0]
        for i in range(1, n):
            dp[0][i] = dp[0][i-1]+grid[0][i]
        for i in range(1, m):
            for j in range(1, n):
                dp[i][j] = min(dp[i-1][j], dp[i][j-1])+grid[i][j]
        return dp[m-1][n-1]
```

# O(MN) Time, O(N) Space

```
class Solution:
    def minPathSum(self, grid):
        if not grid or not grid[0]: return 0
        m, n = len(grid), len(grid[0])
        dp = [0]*n
        dp[0] = grid[0][0]
        for i in range(1, n):
            dp[i] = dp[i-1]+grid[0][i]
        for _ in range(1, m):
            for i in range(n):
                dp[i] = min(dp[i], dp[i-1] if i-1>=0 else sys.maxsize)+grid[_][i]
        return dp[n-1]
```


# O(MN) Time, O(1) Space (Modify original grid)

```
class Solution:
    def minPathSum(self, grid):
        if not grid or not grid[0]: return 0
        m, n = len(grid), len(grid[0])
        for i in range(1, m):
            grid[i][0] = grid[i-1][0]+grid[i][0]
        for i in range(1, n):
            grid[0][i] = grid[0][i-1]+grid[0][i]
        for i in range(1, m):
            for j in range(1, n):
                grid[i][j] = min(grid[i-1][j], grid[i][j-1])+grid[i][j]
        return grid[-1][-1]
```