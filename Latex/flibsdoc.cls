\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{flibsdoc}[Flibbs LaTeX class]

\LoadClass{ctexart}


\makeatletter % change default title style
\renewcommand*\maketitle{%
    \begin{center}% 居中标题
        \bfseries % 默认粗体
        {\par}
        \vskip 40em%
        {\Huge \@title \par}%
        \vskip 40em%
        {\large
         \lineskip 2em%
          \begin{tabular}[t]{c}%
            \@author
          \end{tabular}\par}%
          \vskip 3em%
        {\large \@date \par}%       % Set date in \large size.
      \end{center}\par
}
\makeatother
