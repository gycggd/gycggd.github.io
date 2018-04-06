---
title: "LeetCode 97. Interleaving String"
date: 2018-04-06T14:12:41+08:00
tags:
    - Dynamic Programming
categories:
    - LeetCode
---

![desc](/images/leetcode/97_1.png)

# O(MN) Space

`dp[i][j]`表示`isInterleave(self, s1[:i], s2[:j], s3[:i+j])`.

初始状态：

`dp[i][0]=True` if `dp[i-1][0]==True` and `s1[i-1]==s3[i-1]`
`dp[0][i]=True` if `dp[0][i-1]==True` and `s2[i-1]==s3[i-1]`

递推公式：

`dp[i][j]=(s1[i-1]==s3[i+j-1] and dp[i-1][j]) or (s2[j-1]==s3[i+j-1] and dp[i][j-1])`
分别是从s1取下一个字符和从s2取下一个字符

返回结果：

`dp[-1][-1]`

代码如下：

```
class Solution:
    def isInterleave(self, s1, s2, s3):
        l1, l2 = len(s1), len(s2)
        if len(s3)!=l1+l2: return False
        if l1==0 or l2==0: return (l1 and s1==s3) or (l2 and s2==s3) or not s3
        dp = [[False]*(l2+1) for _ in range(l1+1)]
        dp[0][0] = True
        for i in range(l1):
            if s1[i]==s3[i]: dp[i+1][0]=True
            else: break
        for i in range(l2):
            if s2[i]==s3[i]: dp[0][i+1]=True
            else: break
        for i in range(1, l1+1):
            for j in range(1, l2+1):
                dp[i][j] = (s1[i-1]==s3[i+j-1] and dp[i-1][j]) or (s2[j-1]==s3[i+j-1] and dp[i][j-1])
        return dp[-1][-1]
```

# O(N) Space

基于O(MN)的空间优化版本

代码如下：

```
class Solution:
    def isInterleave(self, s1, s2, s3):
        l1, l2 = len(s1), len(s2)
        if len(s3)!=l1+l2: return False
        if l1==0 or l2==0: return (l1 and s1==s3) or (l2 and s2==s3) or not s3
        dp = [False]*(l2+1)
        dp[0] = True
        for i in range(l2):
            if s2[i]==s3[i]: dp[i+1]=True
            else: break
        for i in range(1, l1+1):
            for j in range(l2+1):
                dp[j] = (s1[i-1]==s3[i+j-1] and dp[j]) or (j-1>=0 and s2[j-1]==s3[i+j-1] and dp[j-1])
        return dp[-1]
```

# O(max(M, N)) Space, with Early Stopping

用一个set来记录有效的(i1, i2)使得`isInterleave(s1[:i], s2[:i], s3[:i+j])`.

在len(s3)上循环，如果set为空，则提前结束。

```
class Solution:
    def isInterleave(self, s1, s2, s3):
        l1, l2 = len(s1), len(s2)
        if len(s3)!=l1+l2: return False
        if l1==0 or l2==0: return (l1 and s1==s3) or (l2 and s2==s3) or not s3
        options = {(0, 0)}
        for c in s3:
            new_options = set()
            for (i1, i2) in options:
                if i1<l1 and s1[i1]==c: new_options.add((i1+1, i2))
                if i2<l2 and s2[i2]==c: new_options.add((i1, i2+1))
            if not new_options: return False
            options = new_options
        return True
```

