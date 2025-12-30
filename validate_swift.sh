#!/bin/bash

# Swift code validation script

echo "=== Checking Swift Files for Common Issues ==="
echo ""

errors=0

# Check for unclosed braces
echo "1. Checking for balanced braces..."
for file in $(find Todoo -name "*.swift"); do
    open_braces=$(grep -o "{" "$file" | wc -l)
    close_braces=$(grep -o "}" "$file" | wc -l)

    if [ "$open_braces" -ne "$close_braces" ]; then
        echo "❌ $file: Unbalanced braces (open: $open_braces, close: $close_braces)"
        errors=$((errors + 1))
    fi
done

if [ $errors -eq 0 ]; then
    echo "✅ All braces are balanced"
fi
echo ""

# Check for required imports
echo "2. Checking for required imports..."
missing_imports=0

# Files that should import SwiftUI
swiftui_files=$(find Todoo/Views -name "*.swift")
for file in $swiftui_files; do
    if ! grep -q "import SwiftUI" "$file"; then
        echo "⚠️  $file: Missing 'import SwiftUI'"
        missing_imports=$((missing_imports + 1))
    fi
done

if [ $missing_imports -eq 0 ]; then
    echo "✅ All view files have required imports"
fi
echo ""

# Check for struct/class definitions
echo "3. Checking struct/class definitions..."
def_errors=0

for file in $(find Todoo -name "*.swift"); do
    # Check if file has struct or class
    if grep -q "struct\|class\|enum" "$file"; then
        # Count struct/class/enum keywords
        definitions=$(grep -c "^struct \|^class \|^enum \|^extension " "$file")
        if [ "$definitions" -eq 0 ]; then
            # Check for indented definitions
            definitions=$(grep -c "struct \|class \|enum " "$file")
        fi

        if [ "$definitions" -eq 0 ]; then
            echo "⚠️  $file: No type definitions found"
            def_errors=$((def_errors + 1))
        fi
    fi
done

if [ $def_errors -eq 0 ]; then
    echo "✅ All files have proper type definitions"
fi
echo ""

# Summary
echo "=== Validation Summary ==="
total_errors=$((errors + def_errors))
if [ $total_errors -eq 0 ]; then
    echo "✅ No major issues found!"
    echo "✅ Code structure appears valid"
else
    echo "⚠️  Found $total_errors potential issues"
fi

exit $total_errors
