---
title: "LeetCode 718. Maximum Length of Repeated Subarray"
date: 2018-04-18T15:58:51+08:00
tags:
    - Dynamic Programming
    - Binary Search
categories:
    - LeetCode
---

# Description

<div class="question-description"><div><p>Given two integer arrays <code>A</code> and <code>B</code>, return the maximum length of an subarray that appears in both arrays.</p>

<p><b>Example 1:</b><br>
</p><pre><b>Input:</b>
A: [1,2,3,2,1]
B: [3,2,1,4,7]
<b>Output:</b> 3
<b>Explanation:</b> 
The repeated subarray with maximum length is [3, 2, 1].
</pre>
<p></p>

<p><b>Note:</b><br>
</p><ol>
<li>1 &lt;= len(A), len(B) &lt;= 1000</li>
<li>0 &lt;= A[i], B[i] &lt; 100</li>
</ol>
<p></p></div></div>

# Solutions

## 动态规划

问题定义：

`dp[i][j]`表示A以第i个字符结尾的子串与B以第j个字符结尾的子串最长共同序列的长度。

初始状态：

`dp[i][0]= 1 if A[i]==B[0] else 0`
`dp[0][j]= 1 if A[0]==B[j] else 0`

递推公式：

`dp[i][j] = (dp[i-1][j-1]+1) if A[i]==B[j] else 0`

返回：

max value in dp

代码如下：

Python:

```
class Solution:
    def findLength(self, A, B):
        m, n = len(A), len(B)
        dp = [[0]*n for _ in range(m)]
        ret = 0
        for i in range(m):
            if A[i]==B[0]:
                dp[i][0] = 1
                ret = max(ret, dp[i][0])
        for j in range(n):
            if A[0]==B[j]:
                dp[0][j] = 1
                ret = max(ret, dp[0][j])
        for i in range(1, m):
            for j in range(1, n):
                dp[i][j] = (dp[i-1][j-1] + 1) if A[i]==B[j] else 0
                ret = max(dp[i][j], ret)
        return ret        
```

Java:

```
class Solution {
    public int findLength(int[] A, int[] B) {
        int m=A.length, n=B.length;
        int[][] dp = new int[m][n];
        for (int i=0; i<m; i++)
            dp[i][0] = (A[i]==B[0]?1:0);
        for (int j=0; j<n; j++)
            dp[0][j] = (A[0]==B[j]?1:0);
        for (int i=1; i<m; i++)
            for (int j=1; j<n; j++)
                dp[i][j] = (A[i]==B[j]?(dp[i-1][j-1]+1):0);
        int ret = 0;
        for (int i=0; i<m; i++)
            for (int j=0; j<n; j++)
                ret = (dp[i][j]>ret)?dp[i][j]:ret;
        return ret;
    }
}
```

## 二分查找

因为最长的可能为`maximum=min(len(A), len(B))`，所以只要在`[0, maximum]`上进行二分查找就行了。

用一个check(l)函数来对A和B所有长度为l的子串进行对比，看是否有长度为l的共同子串。

代码如下：

Python:

```
class Solution:
    def findLength(self, A, B):
        
        def check(length):
            seen = {A[i:i+length]
                    for i in range(len(A) - length + 1)}
            return any(B[j:j+length] in seen
                       for j in range(len(B) - length + 1))

        A = ''.join(map(chr, A))
        B = ''.join(map(chr, B))
        lo, hi = 0, min(len(A), len(B)) + 1
        while lo+1 < hi:
            mi = (lo + hi) // 2
            if check(mi):
                lo = mi
            else:
                hi = mi
        return lo
```

Java:

```
class Solution {
    public int findLength(int[] A, int[] B) {
        
//         String strA = Arrays.stream(A).collect(StringBuilder::new, StringBuilder::appendCodePoint, StringBuilder::append).toString();
//         String strB = Arrays.stream(B).collect(StringBuilder::new, StringBuilder::appendCodePoint, StringBuilder::append).toString();
        StringBuilder sbA = new StringBuilder(), sbB = new StringBuilder();
        for (int i:A)
            sbA.append((char)i);
        for (int i:B)
            sbB.append((char)i);
        String strA=sbA.toString(), strB=sbB.toString();
        
        int left=0, right=Math.min(A.length, B.length)+1;
        while (left+1<right) {
            int mid = (left+right)>>1;
            if (check(strA, strB, mid)) {
                left = mid;
            } else {
                right = mid;
            }
        }
        return left;
    }
    
    private boolean check(String strA, String strB, int len) {
        Set<String> set = new HashSet<>();
        for (int i=0; i<strA.length()-len+1; i++) {
            set.add(strA.substring(i, i+len));
        }
        
        for (int i=0; i<strB.length()-len+1; i++) {
            if (set.contains(strB.substring(i, i+len))) {
                return true;
            }
        }
        return false;
        
    }
}
```