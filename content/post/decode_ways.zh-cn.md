---
title: "LeetCode 91. Decode Ways"
date: 2018-04-19T17:06:01+08:00
categories:
    - LeetCode
tags:
    - Dynamic Programming
---

# Description

<div class="question-description"><div><p>A message containing letters from <code>A-Z</code> is being encoded to numbers using the following mapping:</p>

<pre>'A' -&gt; 1
'B' -&gt; 2
...
'Z' -&gt; 26
</pre>

<p>Given a <strong>non-empty</strong> string containing only digits, determine the total number of ways to decode it.</p>

<p><strong>Example 1:</strong></p>

<pre><strong>Input:</strong> "12"
<strong>Output:</strong> 2
<strong>Explanation:</strong>&nbsp;It could be decoded as "AB" (1 2) or "L" (12).
</pre>

<p><strong>Example 2:</strong></p>

<pre><strong>Input:</strong> "226"
<strong>Output:</strong> 3
<strong>Explanation:</strong>&nbsp;It could be decoded as "BZ" (2 26), "VF" (22 6), or "BBF" (2 2 6).</pre>
</div></div>

# Solutions

# Top-down

令count(S, i)为S[i:]的decode方式数目。

初始状态：

`count(S, i)=1 if i==len(S)`

递推公式：

`count(S, i)=0`
`if S[i] can be decoded, count(S, i)+=count(S, i+1)`
`if S[i+1] can be decoded, count(S, i)+=count(S, i+2)`

代码如下：

Python:
```
class Solution:
    def numDecodings(self, s):
        if not s: return 0
        memo = {}
        def cnt(s, i):
            if i not in memo:
                if i>len(s): ret = 0
                elif i==len(s): ret = 1
                elif s[i]=='0': ret = 0
                elif s[i]=='1' or (s[i]=='2' and i+1<len(s) and s[i+1]<='6'): ret = cnt(s, i+1)+cnt(s,i+2)
                else: ret = cnt(s, i+1) # s[i]>'2'
                memo[i] = ret
            return memo[i]
        return cnt(s, 0)
```

Java:
```
class Solution {
    public int numDecodings(String s) {
        if (s==null || s.length()==0) return 0;
        int len = s.length();
        int memo[] = new int[len];
        for (int i=0; i<len; i++) memo[i] = -1;
        return count(s.toCharArray(), 0, memo);
    }
    
    private int count(char[] ca, int i, int[] memo) {
        if (i>ca.length) 
            return 0;
        if (i==ca.length) 
            return 1;
        if (memo[i]==-1) {
            int ret;
            if (ca[i]=='0') 
                ret = 0;
            else if (ca[i]=='1' || (ca[i]=='2' && i+1<ca.length && ca[i+1]<='6')) 
                ret = count(ca, i+1, memo)+count(ca, i+2, memo);
            else 
                ret = count(ca, i+1, memo);
            memo[i] = ret;
        }   
        return memo[i];
    }
    
}
```

# Bottom-up

用`dp[i]`表示`S[:i]`的decode方式数目。

初始状态：

`dp[0]=1 if S[0]!='0' else 0`

递推公式：

`dp[i]=0`
`if S[i] can be decoded, dp[i]+=dp[i-1]`
`if S[i-1:i+1] can be decoded, dp[i]+=dp[i-2]`

代码如下：

Python:
```
class Solution:
    def numDecodings(self, s):
        if not s: return 0
        dp = [0]*(len(s)+1)
        dp[-1] = 1
        if s[0]!='0': dp[0]=1
        for i in range(1, len(s)):
            if s[i]!='0': dp[i] += dp[i-1]
            if s[i-1]=='1' or (s[i-1]=='2' and s[i]<='6'): dp[i] += dp[i-2]
        return dp[len(s)-1]d
```

Java:
```
class Solution {
    public int numDecodings(String s) {
        if (s==null || s.length()==0) return 0;
        char[] ca = s.toCharArray();
        int dp[] = new int[s.length()];
        if (ca[0]!='0') dp[0]=1;
        for (int i=1; i<s.length(); i++) {
            if (ca[i]!='0') dp[i] += dp[i-1];
            if (ca[i-1]=='1' || (ca[i-1]=='2' && ca[i]<='6')) dp[i] += (i-2>=0? dp[i-2]: 1);
        }
        return dp[s.length()-1];
    }
}
```