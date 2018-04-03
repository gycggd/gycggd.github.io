---
title: "LeetCode 32. Longest Valid Parentheses"
date: 2018-04-03T18:59:41+08:00
tags:
    - Dynamic Programming
    - Stack
categories:
    - LeetCode
---

![desc](/images/leetcode/32_1.png)

三个解法

# 动态规划解法

![dp](/images/leetcode/32_2.png)

代码如下：

```
class Solution:
    def longestValidParentheses(self, s):
        length = [0]*len(s)
        for i in range(len(s)):
            if s[i]=='(':
                length[i] = 0
            elif i-1>=0:
                if s[i-1]=='(':
                    length[i] = (length[i-2] if i-2>=0 else 0)+2
                elif i-1-length[i-1]>=0 and s[i-1-length[i-1]]=='(':
                    length[i] = 2+length[i-1]+(length[i-2-length[i-1]] if i-2-length[i-1]>=0 else 0)
        return max(length) if len(s)>0 else 0
```

# 栈解法

栈解法，遇到匹配的就消除掉，只余下不匹配的index，因此之后栈里面只余下不匹配的index，这些index之间就都是匹配的括号了。

```
class Solution:
    def longestValidParentheses(self, s):
        st = []
        for i in range(len(s)):
            if s[i]=='(':
                st.append(i)
            else:
                if st:
                    if s[st[-1]]=='(':
                        st.pop(-1)
                    else:
                        st.append(i)
                else:
        if not st:
            return len(s)
        start, end = 0, len(s)
        ret = 0
        while st:
            start = st.pop(-1)
            ret = max(ret, end-start-1)
            end = start
        ret = max(ret, end)
        return ret
```

# 从左到右，从右到左

```
class Solution:
    def longestValidParentheses(self, s):
        ret = 0
        l, r = 0, 0
        for c in s:
            if c=='(':
                l += 1
            else:
                r += 1
            if l==r:
                ret = max(ret, l+r)
            elif l<r:
                l, r = 0, 0
        l, r = 0, 0
        for c in s[::-1]:
            if c=='(':
                l += 1
            else:
                r += 1
            if l==r:
                ret = max(ret, l+r)
            elif l>r:
                l, r = 0, 0
        return ret
```