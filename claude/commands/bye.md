# Bye Command

Review current conversation and suggest improvements to `./claude/CLAUDE.md` based on observed preferences and patterns: $ARGUMENTS

## Purpose
Analyze the conversation to identify:
- **User preferences** revealed through requests and feedback
- **Missing rules** that could prevent future misunderstandings  
- **Workflow patterns** that should be documented
- **Pain points** that need addressing in guidelines

## Usage
- `/bye` - Full conversation review with `./claude/CLAUDE.md` improvement suggestions
- `/bye quick` - Focus only on major gaps or preferences identified
- `/bye rules` - Suggest specific new rules based on conversation patterns

## Analysis Focus
- **Communication style preferences** (directness, technical depth, challenge level)
- **Technical priorities** (security, performance, maintainability concerns)
- **Workflow preferences** (tooling usage, file organization, testing approaches)
- **Decision-making patterns** (what triggers research needs, escalation criteria)
- **Code quality standards** (beyond current style rules)

## Output Format
Suggests specific additions/modifications to the sections in `./claude/CLAUDE.md`:
1. **Existed sections Improvement** list the section name and the added rules
4. **New sections** if needed (e.g., specific architectural preferences)
