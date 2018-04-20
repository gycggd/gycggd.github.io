---
title: "LeetCode 87. Scramble String"
date: 2018-04-20T11:57:25+08:00
tags:
    - Dynamic Programming
categories:
    - LeetCode
---

# Description

<div class="question-description"><div><p>Given a string <em>s1</em>, we may represent it as a binary tree by partitioning it to two non-empty substrings recursively.</p>

<p>Below is one possible representation of <em>s1</em> = <code>"great"</code>:</p>

<pre>    great
   /    \
  gr    eat
 / \    /  \
g   r  e   at
           / \
          a   t
</pre>

<p>To scramble the string, we may choose any non-leaf node and swap its two children.</p>

<p>For example, if we choose the node <code>"gr"</code> and swap its two children, it produces a scrambled string <code>"rgeat"</code>.</p>

<pre>    rgeat
   /    \
  rg    eat
 / \    /  \
r   g  e   at
           / \
          a   t
</pre>

<p>We say that <code>"rgeat"</code> is a scrambled string of <code>"great"</code>.</p>

<p>Similarly, if we continue to swap the children of nodes <code>"eat"</code> and <code>"at"</code>, it produces a scrambled string <code>"rgtae"</code>.</p>

<pre>    rgtae
   /    \
  rg    tae
 / \    /  \
r   g  ta  e
       / \
      t   a
</pre>

<p>We say that <code>"rgtae"</code> is a scrambled string of <code>"great"</code>.</p>

<p>Given two strings <em>s1</em> and <em>s2</em> of the same length, determine if <em>s2</em> is a scrambled string of <em>s1</em>.</p>

<p><strong>Example 1:</strong></p>

<pre><strong>Input:</strong> s1 = "great", s2 = "rgeat"
<strong>Output:</strong> true
</pre>

<p><strong>Example 2:</strong></p>

<pre><strong>Input:</strong> s1 = "abcde", s2 = "caebd"
<strong>Output:</strong> false</pre>
</div></div>

# Solutions

`N=len(s1)=len(s2)`

`isScramble(s1, s2)` iff `s1`和`s2`可以分为两部分，这两部分分别符合Scramble String。

即存在`0<k<N`，使得`isScramble(s1[:k], s2[:k]) && isScramble(s1[k:], s2[k:])`或者`isScramble(s1[:k], s2[N-k:]) && isScramble(s1[k:], s2[:N-k])`

对应下面两种匹配方式：

![](/images/leetcode/87_2.png)

下面是两种解法：

## Top-down

这里使用了prefixSum和suffixSum来进行剪枝

* 如果`check(s1[:k], s2[:k])`则s1[:k], s2[:k]的和一定相等，所以先判断prefixSum1和prefixSum2
* 如果`check(s1[:k], s2[N-k:])`则s1[:k], s2[N-k:]的和一定相等，所以先判断prefixSum1和suffixSum2

Python:
```
class Solution:
    def isScramble(self, s1, s2):
        if len(s1)!=len(s2): return False
        def check(S1, S2):
            if S1==S2: return True
            if sorted(S1)!=sorted(S2): return False
            N = len(S1)
            prefixSum1 = 0
            prefixSum2, suffixSum2 = 0, 0
            for i in range(N):
                if i>0 and prefixSum1==prefixSum2 and check(S1[:i], S2[:i]) and check(S1[i:], S2[i:]): return True
                if i>0 and prefixSum1==suffixSum2 and check(S1[:i], S2[N-i:]) and check(S1[i:], S2[:N-i]): return True
            return False
        return check(s1, s2)
```

Java:
```
class Solution {
    public boolean isScramble(String s1, String s2) {
        if (s1.length()!=s2.length()) {
            return false;
        }
        if (s1.equals(s2)) {
            return true;
        }
        int counter1[] = new int[26], counter2[]=new int[26];
        for (char c:s1.toCharArray()) {
            counter1[c-'a']++;
        }
        for (char c:s2.toCharArray()) {
            counter2[c-'a']++;
        }
        for (int i=0; i<26; i++) {
            if (counter1[i]!=counter2[i]) {
                return false;
            }
        }
        int N = s1.length();
        int prefixSum1 = 0;
        int prefixSum2 = 0, suffixSum2 = 0;
        for (int i=0; i<N; i++) {
            if (i>0 && prefixSum1==prefixSum2 && isScramble(s1.substring(0, i), s2.substring(0, i)) &&
                isScramble(s1.substring(i), s2.substring(i))) {
                return true;
            }
            if (i>0 && prefixSum1==suffixSum2 && isScramble(s1.substring(0, i), s2.substring(N-i)) &&
                isScramble(s1.substring(i), s2.substring(0, N-i))) {
                return true;
            }
            prefixSum1 += s1.charAt(i);
            prefixSum2 += s2.charAt(i);
            suffixSum2 += s2.charAt(N-1-i);
        }
        return false;
    }
}
```

## Bottom-up

`dp[l][i][j]`表示`isScramble(s1[i:i+l], s2[j:j+l])`

Python:
```
class Solution:
    def isScramble(self, s1, s2):
        if len(s1)!=len(s2): return False
        N = len(s1)
        dp = [[[False]*N for _ in range(N)] for _ in range(N+1)]
        for l in range(1, N+1):
            for i in range(N-l+1):
                for j in range(N-l+1):
                    if dp[l][i][j]: continue
                    if s1[i:i+l]==s2[j:j+l]:
                        dp[l][i][j] = True
                        continue
                    for k in range(1, l):
                        if dp[k][i][j] and dp[l-k][i+k][j+k]:
                            dp[l][i][j] = True
                            break
                        if dp[k][i][j+l-k] and dp[l-k][i+k][j]:
                            dp[l][i][j] = True
                            break
        return dp[N][0][0]
```

Java:
```
class Solution {
    public boolean isScramble(String s1, String s2) {
        if (s1.length()!=s2.length()) {
            return false;
        }
        int N = s1.length();
        boolean dp[][][] = new boolean[N+1][N][N];
        boolean hasLen[] = new boolean[N+1];
        
        for (int l=1; l<N+1; l++) {
            for (int i=0; i<N-l+1; i++) {
                for (int j=0; j<N-l+1; j++) {
                    if (dp[l][i][j])
                        continue;
                    if (s1.substring(i, i+l).equals(s2.substring(j, j+l))) {
                        dp[l][i][j] = true;
                        hasLen[l] = true;
                        continue;
                    }
                    for (int k=1; k<l; k++) {
                        if (!hasLen[k] || !hasLen[l-k]) {
                            continue;
                        }
                        if (dp[k][i][j] && dp[l-k][i+k][j+k]) {
                            dp[l][i][j] = true;
                            hasLen[l] = true;
                            break;
                        }
                        if (dp[k][i][j+l-k] && dp[l-k][i+k][j]) {
                            dp[l][i][j] = true;
                            hasLen[l] = true;
                            break;
                        }
                    }
                    
                }
            }
        }
        return dp[N][0][0];
    }
}
```