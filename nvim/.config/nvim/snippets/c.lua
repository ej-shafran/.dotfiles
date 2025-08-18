local function to_upper_case(str)
  str = str:gsub("(.[A-Z])", function(s)
    return s:sub(1, 1) .. "_" .. s:sub(2, 2):upper()
  end)

  return str:upper()
end

return {
  s(
    "defguard",
    fmt(
      [[
      #ifndef {guard}
      #define {guard}

      {}

      #endif // {guard}
      ]],
      {
        i(1),
        guard = f(function()
          return to_upper_case(vim.fn.expand "%:t:r") .. "_H_"
        end),
      }
    )
  ),
}
