local {{ project }} = require("{{path}}")

describe('double-spec', function()

  it('exists', function()
    assert.truthy({{project}})
  end)

  it('runs inside nginx', function ()
    assert.truthy(ngx)
  end)
end)
