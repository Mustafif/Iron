#!/bin/bash

# Test script for Phase 3 knowledge graph and linking features
# This script tests the wiki-style linking, backlinks, tags, and Metal-accelerated graph view

set -e

echo "🧠 Testing Iron Phase 3: Knowledge Graph & Linking System"
echo "=========================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test directory
VAULT_DIR="$HOME/.iron/test_vault_phase3"
NOTES_DIR="$VAULT_DIR/notes"

echo -e "${BLUE}Setting up test vault with interconnected notes...${NC}"

# Clean and create test vault
rm -rf "$VAULT_DIR"
mkdir -p "$NOTES_DIR"

# Create interconnected notes with wiki links and tags
cat > "$NOTES_DIR/Project Management.md" << 'EOF'
# Project Management

This note covers the fundamentals of [[Project Planning]] and team coordination.

## Key Areas
- [[Task Management]]
- [[Team Communication]]
- [[Resource Allocation]]
- [[Risk Management]]

## Related Topics
See also: [[Agile Development]], [[Scrum Framework]], [[Kanban Boards]]

#management #productivity #teams #planning
EOF

cat > "$NOTES_DIR/Project Planning.md" << 'EOF'
# Project Planning

Essential phase of [[Project Management]] that involves defining objectives and creating roadmaps.

## Planning Methods
- [[Gantt Charts]] for timeline visualization
- [[Work Breakdown Structure]] for task decomposition
- [[Critical Path Method]] for dependency mapping

## Tools and Techniques
- [[Requirements Analysis]]
- [[Stakeholder Mapping]]
- [[Risk Assessment]]

Connects to: [[Agile Development]] and [[Waterfall Methodology]]

#planning #management #strategy #analysis
EOF

cat > "$NOTES_DIR/Agile Development.md" << 'EOF'
# Agile Development

Iterative approach to software development that emphasizes collaboration and flexibility.

## Core Principles
From the [[Agile Manifesto]]:
- Individuals over processes
- Working software over documentation
- Customer collaboration over contracts
- Responding to change over plans

## Frameworks
- [[Scrum Framework]] - most popular
- [[Kanban Boards]] - continuous flow
- [[Extreme Programming]] (XP)

## Connection to Management
Agile is a key part of modern [[Project Management]] and requires careful [[Project Planning]].

#agile #development #software #methodology #teams
EOF

cat > "$NOTES_DIR/Scrum Framework.md" << 'EOF'
# Scrum Framework

Specific implementation of [[Agile Development]] with defined roles and ceremonies.

## Roles
- Product Owner
- Scrum Master
- Development Team

## Events
- Sprint Planning
- Daily Standups
- Sprint Review
- Sprint Retrospective

## Artifacts
- Product Backlog
- Sprint Backlog
- Increment

Links to [[Task Management]] and [[Team Communication]] practices.

#scrum #agile #framework #roles #events
EOF

cat > "$NOTES_DIR/Task Management.md" << 'EOF'
# Task Management

Critical component of [[Project Management]] involving organizing and tracking work items.

## Methodologies
- [[Getting Things Done]] (GTD)
- [[Kanban Boards]] for visual workflow
- [[Time Boxing]] techniques
- [[Priority Matrix]] (Eisenhower Matrix)

## Tools
- Digital task managers
- [[Gantt Charts]] for complex projects
- Simple todo lists

Related to [[Team Communication]] and [[Resource Allocation]].

#tasks #productivity #organization #workflow
EOF

cat > "$NOTES_DIR/Team Communication.md" << 'EOF'
# Team Communication

Fundamental aspect of successful [[Project Management]] and [[Agile Development]].

## Communication Channels
- Synchronous: meetings, calls
- Asynchronous: email, chat, documentation
- Visual: [[Kanban Boards]], dashboards

## Best Practices
- Regular check-ins (see [[Scrum Framework]] daily standups)
- Clear documentation
- Active listening
- Feedback loops

Connected to [[Task Management]] and all team-based work.

#communication #teams #collaboration #meetings
EOF

cat > "$NOTES_DIR/Kanban Boards.md" << 'EOF'
# Kanban Boards

Visual workflow management system used in [[Agile Development]] and [[Task Management]].

## Board Structure
- To Do
- In Progress
- Review
- Done

## Principles
- Visualize workflow
- Limit work in progress (WIP)
- Manage flow
- Make policies explicit

Used in both [[Scrum Framework]] and standalone [[Project Management]].

#kanban #visual #workflow #agile #boards
EOF

cat > "$NOTES_DIR/Getting Things Done.md" << 'EOF'
# Getting Things Done

Personal productivity methodology by David Allen, relevant to [[Task Management]].

## Core Concepts
- Capture everything
- Clarify what it means
- Organize by category
- Reflect through review
- Engage with confidence

## Applications
Can be integrated with:
- [[Project Planning]] processes
- [[Team Communication]] structures
- [[Time Boxing]] techniques

#gtd #productivity #personal #methodology #capture
EOF

cat > "$NOTES_DIR/Time Boxing.md" << 'EOF'
# Time Boxing

Technique used in [[Task Management]] and [[Agile Development]] to allocate fixed time periods.

## Applications
- Sprints in [[Scrum Framework]] (2-4 weeks)
- Pomodoro Technique (25 minutes)
- Meeting time limits
- Development iterations

## Benefits
- Forces prioritization
- Prevents perfectionism
- Improves estimation
- Creates urgency

Links to [[Project Planning]] and [[Getting Things Done]] principles.

#timeboxing #productivity #focus #sprints #pomodoro
EOF

cat > "$NOTES_DIR/Research Notes.md" << 'EOF'
# Research Notes

Collection of research findings related to productivity and management.

## Key Studies
- Effectiveness of [[Agile Development]] in large organizations
- Impact of [[Team Communication]] on project success
- [[Time Boxing]] effects on cognitive performance

## Methodology Comparisons
- [[Scrum Framework]] vs traditional [[Project Management]]
- [[Kanban Boards]] adoption rates
- [[Getting Things Done]] implementation success

#research #studies #effectiveness #data #analysis
EOF

# Create vault configuration
cat > "$VAULT_DIR/vault.json" << EOF
{
  "name": "Test Vault Phase 3",
  "version": "1.0",
  "created": "$(date -u +"%Y-%m-%dT%H:%M:%S.000Z")",
  "settings": {
    "enableLinking": true,
    "enableBacklinks": true,
    "enableGraphView": true,
    "autoDetectLinks": true
  }
}
EOF

echo -e "${GREEN}✓ Created test vault with 10 interconnected notes${NC}"
echo -e "${BLUE}Notes contain:${NC}"
echo "  - 30+ wiki-style links [[Note Title]]"
echo "  - 25+ hashtags #category"
echo "  - Complex interconnection patterns"
echo "  - Multiple clustering topics"

# Build the project
echo -e "${BLUE}Building Iron with Phase 3 features...${NC}"
cd "$(dirname "$0")"

if swift build; then
    echo -e "${GREEN}✓ Build successful${NC}"
else
    echo -e "${RED}✗ Build failed${NC}"
    exit 1
fi

# Launch the app with test vault
echo -e "${BLUE}Launching Iron with test vault...${NC}"

# Create a temporary script to set the vault path
cat > /tmp/launch_iron_phase3.sh << EOF
#!/bin/bash
export IRON_VAULT_PATH="$VAULT_DIR"
cd "$(dirname "$0")"
swift run IronApp
EOF

chmod +x /tmp/launch_iron_phase3.sh

echo -e "${YELLOW}Testing Instructions:${NC}"
echo "==================="
echo ""
echo -e "${GREEN}1. Link System Testing:${NC}"
echo "   - Open any note and verify wiki links [[Note Title]] are highlighted"
echo "   - Click on wiki links to navigate between notes"
echo "   - Try typing [[ to see auto-completion suggestions"
echo "   - Create new links and verify they update automatically"
echo ""
echo -e "${GREEN}2. Backlink Testing:${NC}"
echo "   - Open 'Agile Development' note (highly connected)"
echo "   - Check backlinks panel shows all notes linking to it"
echo "   - Verify backlink context snippets are displayed"
echo ""
echo -e "${GREEN}3. Tag System Testing:${NC}"
echo "   - Verify hashtags #management, #agile, #productivity are highlighted"
echo "   - Check tag hierarchy (e.g., nested tags if any)"
echo "   - Filter notes by tags"
echo ""
echo -e "${GREEN}4. Graph View Testing:${NC}"
echo "   - Switch to Graph View (should be a new tab/panel)"
echo "   - Verify Metal-accelerated rendering (smooth 60fps)"
echo "   - Test different layout algorithms:"
echo "     * Force-Directed (default) - physics simulation"
echo "     * Hierarchical - tree structure"
echo "     * Circular - nodes in circle"
echo "     * Grid - organized grid"
echo "     * Clusters - grouped by topics"
echo ""
echo -e "${GREEN}5. Graph Interaction Testing:${NC}"
echo "   - Click and drag nodes to move them"
echo "   - Zoom in/out with mouse wheel or gestures"
echo "   - Pan the view by dragging empty space"
echo "   - Click nodes to select them"
echo "   - Verify node colors indicate importance/connections"
echo "   - Check edge thickness shows connection strength"
echo ""
echo -e "${GREEN}6. Performance Testing:${NC}"
echo "   - Check frame rate stays near 60fps in graph view"
echo "   - Verify smooth animations during layout changes"
echo "   - Test with physics enabled/disabled"
echo ""
echo -e "${GREEN}7. Link Validation Testing:${NC}"
echo "   - Create a broken link [[Non-existent Note]]"
echo "   - Verify it's highlighted differently (orange)"
echo "   - Check suggestions for fixing broken links"
echo ""

echo -e "${BLUE}Expected Graph Structure:${NC}"
echo "========================"
echo ""
echo "Hub Nodes (most connected):"
echo "  - Project Management (central hub)"
echo "  - Agile Development (methodology hub)"
echo "  - Task Management (productivity hub)"
echo ""
echo "Clusters:"
echo "  - Management: Project Management, Project Planning, Resource Allocation"
echo "  - Agile: Agile Development, Scrum Framework, Kanban Boards"
echo "  - Productivity: Task Management, Getting Things Done, Time Boxing"
echo "  - Communication: Team Communication, meetings, collaboration"
echo ""
echo "Orphan Nodes:"
echo "  - Research Notes (should have few connections)"
echo ""

echo -e "${YELLOW}Graph Statistics Expected:${NC}"
echo "  - Notes: 10"
echo "  - Total Links: 30+"
echo "  - Tags: 25+"
echo "  - Orphans: 0-1"
echo "  - Clusters: 3-4"
echo ""

echo -e "${BLUE}Press Enter to launch Iron, or Ctrl+C to cancel...${NC}"
read

# Launch the application
exec /tmp/launch_iron_phase3.sh
