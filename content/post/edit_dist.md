---
title: "LeetCode 72. Edit Distance"
date: 2018-03-30T19:39:00+08:00
tags:
    - Dynamic Programming
categories:
    - LeetCode
---

![72](/images/leetcode/72_1.png)

这一题是一道经典的动态规划题。搞一个dp数组`dp[i][j]`表示`w1[:i]`和`w2[:j]`的edit distance。然后初始状态为`dp[i][0]=i, dp[0][j]=j`。

递推如下：

* If `w1[i-1]==w2[j-1]`, `dp[i][j]=dp[i-1][j-1]`
* If `w1[i-1]!=w2[j-1]`, `dp[i][j]=min(dp[i-1][j-1], dp[i][j-1], dp[i-1][j])+1`. 依次代表替换，删除和添加一个字符的情况。

代码如下：

```
class Solution(object):
    def minDistance(self, w1, w2):
        m, n = len(w1), len(w2)
        if not m or not n: return max(m, n)
        dp = [[0]*(n+1) for _ in range(m+1)]
        for i in range(m+1): 
            dp[i][0] = i
        for j in range(n+1):
            dp[0][j] = j
        for i in range(1, m+1):
            for j in range(1, n+1):
                if w1[i-1]==w2[j-1]: dp[i][j] = dp[i-1][j-1]
                else: dp[i][j] = min(dp[i-1][j-1], dp[i-1][j], dp[i][j-1])+1
        return dp[m][n]
```