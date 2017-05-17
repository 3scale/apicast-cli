describe('double-spec', function()

  it('runs the test', function ()
    assert.are.equal('1', '1')
  end)

  it('checks if nginx', function ()
    assert.truthy(ngx)
  end)
end)
